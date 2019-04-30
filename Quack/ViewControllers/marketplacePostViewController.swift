//
//  marketplacePostViewController.swift
//  Quack
//
//  Created by Katya  on 4/27/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class marketplacePostViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return marketplaceCategories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return marketplaceCategories[row]
    }    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        selectedPriority = marketplaceCategories[row]
        categoryPicker.text = selectedPriority
    }
    var selectedPriority: String?
    
    var marketplaceCategories = ["Books", "Electronics", "Furniture", "Miscellaneous"]
    
    @IBOutlet weak var marketplaceImageUploadView: UIImageView!
    @IBOutlet weak var marketplaceTitleUploadLabel: UITextField!
    @IBOutlet weak var marketplacePriceUploadLabel: UITextField!
    @IBOutlet weak var marketplaceDescriptionUploadLabel: UITextView!
    @IBOutlet weak var marketplacePost: UIButton!
   
    
    func createPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        categoryPicker.inputView = pickerView
    }
    
    func dissmissPickerView(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dissmissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        categoryPicker.inputAccessoryView = toolBar
    }
    
    @objc func dissmissKeyboard(){
        view.endEditing(true)
    }
    @IBOutlet weak var categoryPicker: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        marketplaceImageUploadView.addGestureRecognizer(tapGesture)
        marketplaceImageUploadView.isUserInteractionEnabled = true
        createPickerView()
        dissmissPickerView()
        
    }
  
    
    var selectedImage: UIImage?
    
    @objc func handleSelectPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func marketplacePost_touchUpInside(_ sender: Any) {
        self.saveFIRData()
//        if let postingImg = self.selectedImage, let imageData = postingImg.jpegData(compressionQuality: 0.1){
//            let photoIdString = NSUUID().uuidString
//            let storageRef = Storage.storage().reference(forURL: "gs://quack-f1544.appspot.com").child("marketPlacePosts").child(photoIdString)
//            storageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
//                if error != nil{
//                    return
//                }
//                let photoUrl = storageRef.downloadURL { (url, error) in
//                    guard let downloadURL = url else {
//                        return
//                    }
//                }
//            })
//        }
//        var ref: DocumentReference? = nil
//        ref = Firestore.firestore().collection("Marketplace").addDocument(data: [
//            "adPrice": marketplaceDescriptionUploadLabel.text,
//            "adTitle": marketplaceTitleUploadLabel.text!,
//            "idUser": String(Auth.auth().currentUser!.uid),
//            "adDate": Int(NSDate().timeIntervalSince1970 * 1000),
//            "editDate": Int(NSDate().timeIntervalSince1970 * 1000),
//            "adStatus": "Active",
//            "imageOne": ""
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
//        //MarketPlaceViewController.tabBarController?.selectedIndex = 2 //huh?
    }
    func saveFIRData(){
        self.uploadImage(self.marketplaceImageUploadView.image!){ url in
            
            self.saveImage(adTitle: self.marketplaceTitleUploadLabel.text!, adPrice: self.marketplacePriceUploadLabel.text!, adDescription: self.marketplaceDescriptionUploadLabel.text!, imageOne: url!){ success in
                if success != nil{
                    print("yeah!")
                }
            }
        }
    }

    @IBAction func marketplaceCancelPostButton(_ sender: Any) {
        
    }
}
extension marketplacePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            marketplaceImageUploadView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
//connects to MarketplaceDetailViewController
extension marketplacePostViewController{
    
    func uploadImage(_ image: UIImage, completion: @escaping (_ url: URL?) -> ()){
        let storageRef = Storage.storage().reference(forURL: "gs://quack-f1544.appspot.com").child(NSUUID().uuidString)
            //.child("myimage.jpeg")
        let imgData = marketplaceImageUploadView.image?.jpegData(compressionQuality: 0.1)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        storageRef.putData(imgData!, metadata: metaData){
            (metadata, error) in
            if error == nil{
                print("success")
                storageRef.downloadURL(completion: {(url, error) in
                    completion(url)
                })
            } else{
                print("error in saving image")
                completion(nil)
            }
        }
    }
    
    func saveImage(adTitle: String, adPrice: String, adDescription: String, imageOne: URL, completion: @escaping ((_ url: URL?) -> ())){
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("marketplace_posts").addDocument(data: [
            "adPrice": marketplacePriceUploadLabel.text as Any,
            "adDescription": marketplaceDescriptionUploadLabel.text,
            "adTitle": marketplaceTitleUploadLabel.text!,
            "idUser": String(Auth.auth().currentUser!.uid),
            "adDate": Int(NSDate().timeIntervalSince1970 * 1000),
            "editDate": Int(NSDate().timeIntervalSince1970 * 1000),
            "adStatus": "active",
            "imageOne": imageOne.absoluteString,
            "imageTwo": "null",
            "imageThree": "null",
            "adCategory": categoryPicker.text as Any
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}
