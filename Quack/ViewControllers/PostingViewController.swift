//
//  PostingViewController.swift
//  Quack
//
//  Created by Katya  on 4/7/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class PostingViewController: UIViewController {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
        
        /*
         let ref = Firestore.firestore()
         let uid = user!.user.uid
         ref.collection("Marketplace").document(uid).setData([
         "email": self.emailTextField.text!,
         "username": self.usernameTextField.text!])
         */
        if let postingImg = self.selectedImage, let imageData = postingImg.jpegData(compressionQuality: 0.1){
            let photoIdString = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: "gs://quack-f1544.appspot.com").child("marketPlacePosts").child(photoIdString)
            storageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
                if error != nil{
                    return
                }
                let photoUrl = storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                        /*
                        var citiesRef = db.collection("cities");
                        
                        citiesRef.doc("SF").set({
                            name: "San Francisco", state: "CA", country: "USA",
                            capital: false, population: 860000,
                            regions: ["west_coast", "norcal"] });
 */
                       
              //  self.sendDataToDatabase(photoUrl: photoUrl!)
                    }
                }
            })
        }
        
        //saves the document in Firestore.firestore()
        //Need to find a way how to store:
        //time it was stored at
        //adCategory - user's input
        //adDate
        //adDescription - user's input
        //adPrice - user's input
        //adStatus - hardcode the status to Active for now
        //adTitle - user's input
        //editDate
        //idUser
        //imageOne
        //imageTwo
        //imageThree
        
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("Marketplace").addDocument(data: [
            "adPrice": captionTextView.text,
            "adTitle": "Japan",
            "idUser": String(Auth.auth().currentUser!.uid),
            "adDate": Int(NSDate().timeIntervalSince1970 * 1000),
            "editDate": Int(NSDate().timeIntervalSince1970 * 1000),
            "adStatus": "Active"
                
                //Timestamp(date: Date())
           // "imageOne": self.photoIdString - how to store the URL of the image???
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
    }
    func sendDataToDatabase(photoUrl: String){
       // let ref = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser else  {
            return
        }
        //how to set a document so that it is saved under post's unique ID?
        let currentUserId = currentUser.uid
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("marketplace_posts").addDocument(data: [
            "caption": self.captionTextView.text!,
            "imageUrl": self.photo.image!,//how to store image info
            "userId": currentUserId])
        //add editDate: use the same value as you do for adDate (timestamp)
                }

    }
extension PostingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            photo.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
