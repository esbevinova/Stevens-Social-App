//
//  SignUpViewController.swift
//  Quack
//
//  Created by Katya  on 3/24/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //below 3 lines just adjusts the color of the pointed arrow
        usernameTextField.tintColor = UIColor.black
        emailTextField.tintColor = UIColor.black
        passwordTextField.tintColor = UIColor.black
        
        signUpButton.isEnabled = false
        handleTextField()
    }
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                signUpButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
                signUpButton.isEnabled = false
                return
        }
        
        signUpButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        signUpButton.isEnabled = true
    }
    //need to add error handler, including nil
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any) {
     
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
            /*
            let ref = Database.database().reference()
            let usersReference = ref.child("users")
            let uid = user!.user.uid
            let newUserReference = usersReference.child(uid)
            newUserReference.setValue(["username": self.usernameTextField.text!, "email": self.emailTextField.text!])
             
            */
            let ref = Firestore.firestore()
            let uid = user!.user.uid
            ref.collection("Users").document(uid).setData([
                "email": self.emailTextField.text!,
                "username": self.usernameTextField.text!])
            
        })
        self.performSegue(withIdentifier: "signUpToTabbarVC", sender: nil)
    }
}
