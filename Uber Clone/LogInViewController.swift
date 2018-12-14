//
//  LogInViewController.swift
//  Uber Clone
//
//  Created by Emre Durukan on 12.12.2018.
//  Copyright © 2018 Emre Durukan. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    // IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginUser(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide both email and password")
        } else {
            // LOG IN
            if let email = emailTextField.text {
                if let password = passwordTextField.text {
                    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                        if error != nil {
                            self.displayAlert(title: "Error", message: error!.localizedDescription)
                        } else {
                            if authResult?.user.displayName == "Driver" {
                                self.performSegue(withIdentifier: "loginDriverSeque", sender: nil)
                            } else {
                                self.performSegue(withIdentifier: "loginRiderSeque", sender: nil)
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
