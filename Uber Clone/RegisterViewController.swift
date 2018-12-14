//
//  ViewController.swift
//  Uber Clone
//
//  Created by Emre Durukan on 11.12.2018.
//  Copyright © 2018 Emre Durukan. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    // IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var riderDriverSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerUser(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide both email and password")
        }
        else if passwordTextField.text != confirmPassword.text {
            displayAlert(title: "Match Issue", message: "Passwords you entered do not match")
        }
        else {
            // REGISTER
            if let email = emailTextField.text {
                if let password = passwordTextField.text {
                    Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                        if error != nil {
                            self.displayAlert(title: "Error", message: error!.localizedDescription)
                        } else {
                            print("Sign Up Success")
                            
                            if self.riderDriverSwitch.isOn {
                                // Driver
                                print("Driver")
                                let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                req?.displayName = "Driver"
                                req?.commitChanges(completion: nil)
                                self.performSegue(withIdentifier: "registerDriverSeque", sender: nil)
                            } else {
                                // Rider
                                print("Rider")
                                let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                req?.displayName = "Rider"
                                req?.commitChanges(completion: nil)
                                self.performSegue(withIdentifier: "registerRiderSeque", sender: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

