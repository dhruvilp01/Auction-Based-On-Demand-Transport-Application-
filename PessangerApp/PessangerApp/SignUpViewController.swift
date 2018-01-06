//
//  SignUpViewController.swift
//  PessangerApp
//
//  Created by Dhruvil Patel on 7/21/17.
//  Copyright © 2017 Dhruvil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate{

   
var ref : DatabaseReference!
    
   
    
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       emailTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.delegate = self
        
        ref = Database.database().reference()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
   
    
    @IBAction func RegisterBtnPressed(_ sender: Any) {
        
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
           
           
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    print("You have successfully signed up")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                    let userID: String = user!.uid
                    let userEmail: String = self.emailTextField.text!
                    //let userPassword: String = self.passwordTextField.text!
                    let username: String = self.nameTextField.text!
                    
                    self.ref.child("users").child(userID).setValue(["type":username, "email":userEmail])
                    
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                
                
            }
        }

        
    }
    
    

     
    

}
