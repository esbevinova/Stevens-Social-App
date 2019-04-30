//
//  SocialPostViewController.swift
//  Quack
//
//  Created by Katya  on 4/27/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class SocialPostViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    private var datePicker: UIDatePicker? //eventdate
    
    
    var socialCategories = ["Sport", "Movie/Theatre", "Social meetup", "Other"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return socialCategories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return socialCategories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        selectedPriority = socialCategories[row]
        socialPostCategoryLabel.text = selectedPriority
    }
    var selectedPriority: String?
    
    @IBOutlet weak var socialPostImageView: UIImageView!
    
    @IBOutlet weak var socialPostTitleLabel: UITextField!
    
    @IBOutlet weak var socialPostEventDateLabel: UITextField!
    
    @IBOutlet weak var socialPostDescriptionView: UITextView!
    
    
    @IBOutlet weak var socialPostCategoryLabel: UITextField!
    
    
    @IBOutlet weak var socialPostButton: UIButton!
    
    //category
    func createPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        socialPostCategoryLabel.inputView = pickerView
    }
    //category
    func dissmissPickerView(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dissmissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        socialPostCategoryLabel.inputAccessoryView = toolBar
    }
    
    @objc func dissmissKeyboard(){
        view.endEditing(true)
    }

    
    
    @IBAction func socialPostButton_touchUpInside(_ sender: Any) {
        self.saveFIRData()
    }
    
    func saveFIRData(){
        self.uploadImage(self.socialPostImageView.image!){ url in
            
            self.saveImage(adTitle: self.socialPostTitleLabel.text!, adDescription: self.socialPostDescriptionView.text!, imageOne: url!){ success in
                if success != nil{
                    print("yeah!")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        socialPostImageView.addGestureRecognizer(tapGesture)
        socialPostImageView.isUserInteractionEnabled = true
        createPickerView()
        dissmissPickerView()
        datePicker = UIDatePicker() //event date
        datePicker?.datePickerMode = .date //eventdate
        datePicker?.addTarget(self, action: #selector(SocialPostViewController.dateChanged(datePicker:)), for: .valueChanged)
        
//        let tapDateGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.viewTapped(UITapGestureRecognizer)))
//
//        view.addGestureRecognizer(tapDateGesture)
        
        socialPostEventDateLabel.inputView = datePicker //eventdate
    }
    
    func viewTapped(_: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        socialPostEventDateLabel.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    var selectedImage: UIImage?
    
    @objc func handleSelectPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
}

extension SocialPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            socialPostImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
//connects to MarketplaceDetailViewController
extension SocialPostViewController{
    
    func uploadImage(_ image: UIImage, completion: @escaping (_ url: URL?) -> ()){
        let storageRef = Storage.storage().reference(forURL: "gs://quack-f1544.appspot.com").child("myimage.jpeg")
        let imgData = socialPostImageView.image?.jpegData(compressionQuality: 0.1)
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
    
    func saveImage(adTitle: String, adDescription: String, imageOne: URL, completion: @escaping ((_ url: URL?) -> ())){
        
        //converting string back to timestamp
        let isoDate = socialPostEventDateLabel.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from:isoDate!)!

        
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("social_posts").addDocument(data: [
            "adDescription": socialPostDescriptionView.text,
            "adTitle": socialPostTitleLabel.text!,
            "idUser": String(Auth.auth().currentUser!.uid),
            "adDate": CLong(NSDate().timeIntervalSince1970 * 1000),
            "editDate": CLong(NSDate().timeIntervalSince1970 * 1000),
            "eventDate": CLong(date.timeIntervalSince1970 * 1000) ,//Timestamp(date: date),
            "adStatus": "active",
            "imageOne": imageOne.absoluteString,
            "imageTwo": "null",
            "imageThree": "null",
            "adCategory": socialPostCategoryLabel.text as Any
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}

