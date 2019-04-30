//
//  SigninViewController.swift
//  Quack
//
//  Created by Katya  on 3/24/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import UIKit
import FirebaseAuth

class SigninViewController: UIViewController {
    
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
 
        emailTextField.tintColor = UIColor.black
        passwordTextField.tintColor = UIColor.black
        handleTextField()
    }
    //keeps the user logged in - 4 lines of code
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
        }
    }
    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                signInButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
                signInButton.isEnabled = false
                return
        }
        
        signInButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        signInButton.isEnabled = true
    }
    /*
     @IBAction func signInButton_TouchUpInside(_ sender: Any) {
     }
     override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
 */
    @IBAction func signInButton_TouchUpInside(_ sender: Any) {
        
        //add extra function to validate the stevens.edu email
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
        })
    }
}
        /*
        emailTextField.backgroundColor = UIColor.clear
       
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
 */
        /*
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 330, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)
        
        
        passwordTextField.backgroundColor = UIColor.clear
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 330, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)
 */

    

