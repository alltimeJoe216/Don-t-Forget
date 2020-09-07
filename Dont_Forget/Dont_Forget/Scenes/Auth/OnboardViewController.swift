//
//  OnboardViewController.swift
//  Dont_Forget
//
//  Created by Joseph Veverka on 9/5/20.
//  Copyright © 2020 Joseph Veverka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class OnboardViewController: UIViewController {
    
    @IBOutlet var lastNameTF: UITextField!
    @IBOutlet var firstNameTF: UITextField!
    @IBOutlet var getStartedButton: UIButton!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTF.addBottomBorder()
        lastNameTF.addBottomBorder()
        emailTF.addBottomBorder()
        passwordTF.addBottomBorder()
        Utilities.styleHollowButton(getStartedButton)
    }
    
    
    
    @IBAction func getStartedButtonTapped(_ sender: Any) {
        
        // Validate text fields
        let firstname = firstNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        // Create User
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            // Check for errors
            if err != nil {
                
                print("Error: \(err?.localizedDescription ?? "")")
                
            } else {
                
                let db = Firestore.firestore()
                
                db.collection("users").addDocument(data: ["firstname" : firstname, "lastname" : lastName, "uid" : result!.user.uid]) { (err) in
                    if let err = err {
                        fatalError("Ouch: \(err)")
                    }
                }
            }
            self.transitionToHome()
        }
    }
    
    func transitionToHome() {
        
        let homeVC = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
        
        navigationController?.popToViewController(homeVC!, animated: true)
    }
}
