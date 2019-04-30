//
//  HousingPostViewController.swift
//  Quack
//
//  Created by Katya  on 4/27/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class HousingPostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return housingPostCategories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return housingPostCategories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        selectedPriority = housingPostCategories[row]
        housingCategories.text = selectedPriority
    }
    var selectedPriority: String?
    
    var housingPostCategories = ["Need a Room", "Have spare room"]
    
    func createPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        housingCategories.inputView = pickerView
    }
    
    func dissmissPickerView(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dissmissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        housingCategories.inputAccessoryView = toolBar
    }
    
    @objc func dissmissKeyboard(){
        view.endEditing(true)
    }
    
    

    @IBOutlet weak var housingPostingImageView: UIImageView!
    
    @IBOutlet weak var housingPostingTitleLabel: UITextField!
    
    
    @IBOutlet weak var housingPostingRentLabel: UITextField!
    
    @IBOutlet weak var housingPostingDescriptionLabel: UITextView!
    
    @IBOutlet weak var housingCategories: UITextField!
    
    @IBOutlet weak var housingPostButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        housingPostingImageView.addGestureRecognizer(tapGesture)
        housingPostingImageView.isUserInteractionEnabled = true
        createPickerView()
        dissmissPickerView()
        
    }
    var selectedImage: UIImage?
    
    @objc func handleSelectPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func housingPostButton_touchUpInside(_ sender: Any) {
        self.saveFIRData()
    }
    func saveFIRData(){
        self.uploadImage(self.housingPostingImageView.image!){ url in
            
            self.saveImage(adTitle: self.housingPostingTitleLabel.text!, adPrice: self.housingPostingRentLabel.text!, adDescription: self.housingPostingDescriptionLabel.text!, imageOne: url!){ success in
                if success != nil{
                    print("yeah!")
                }
            }
        }
    }
    
}

extension HousingPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            housingPostingImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
//connects to MarketplaceDetailViewController
extension HousingPostViewController{
    
    func uploadImage(_ image: UIImage, completion: @escaping (_ url: URL?) -> ()){
        let storageRef = Storage.storage().reference(forURL: "gs://quack-f1544.appspot.com").child("myimage.jpeg")
        let imgData = housingPostingImageView.image?.jpegData(compressionQuality: 0.1)
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
        ref = Firestore.firestore().collection("housing_posts").addDocument(data: [
            "adRent": housingPostingRentLabel.text as Any,
            "adDescription": housingPostingDescriptionLabel.text,
            "adTitle": housingPostingTitleLabel.text!,
            "idUser": String(Auth.auth().currentUser!.uid),
            "adDate": Int(NSDate().timeIntervalSince1970 * 1000),
            "editDate": Int(NSDate().timeIntervalSince1970 * 1000),
            "adStatus": "active",
            "imageOne": imageOne.absoluteString,
            "imageTwo": "null",
            "imageThree": "null",
            "adCategory": housingCategories.text as Any
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}



