//
//  OnboardViewController.swift
//  Dont_Forget
//
//  Created by Joseph Veverka on 9/5/20.
//  Copyright © 2020 Joseph Veverka. All rights reserved.
//

import UIKit
import CoreGraphics
import Firebase
import FirebaseAuth

class OnboardViewController: UIViewController {
    
    enum LoginType {
        case signUp
        case signIn
    }
    
    //MARK: - IBOutlet
    @IBOutlet var firstnameLabel: UILabel!
    @IBOutlet var lastnameLabel: UILabel!
    @IBOutlet var lastNameTF: UITextField!
    @IBOutlet var firstNameTF: UITextField!
    @IBOutlet var getStartedButton: UIButton!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    //MARK: -Properties
    var selectedLoginType: LoginType = .signIn {
        didSet {
            switch selectedLoginType {
            case .signIn:
                getStartedButton.setTitle("Welcome Back!", for: .normal)
                
            case .signUp:
                getStartedButton.setTitle("Get Started", for: .normal)
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTF.addBottomBorder()
        lastNameTF.addBottomBorder()
        emailTF.addBottomBorder()
        passwordTF.addBottomBorder()
        Utilities.styleHollowButton(getStartedButton)
    }
    
    
    @IBAction func signUpSignInSegmentedAction(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedLoginType = .signIn
            passwordTF.textContentType = .password
        default:
            selectedLoginType = .signUp
            passwordTF.textContentType = .newPassword
        }
    }
    
    var toggleState = false
    var originalFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    let sizeChange: CGFloat = -100
    
    
    @IBAction func getStartedButtonTapped(_ sender: Any) {
        
        // Validate text fields
        let firstname = firstNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.segmentedControl.selectedSegmentIndex = 1
        firstNameTF.fadeOut()
        lastNameTF.fadeOut()
        firstnameLabel.fadeOut()
        lastnameLabel.fadeOut()
    
        
        //         Create User
//        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
//
//            // Check for errors
//            if err != nil {
//
//                print("Error: \(err?.localizedDescription ?? "")")
//
//            } else {
//
//                let db = Firestore.firestore()
//
//                db.collection("users").addDocument(data: ["firstname" : firstname, "lastname" : lastName, "uid" : result!.user.uid]) { (err) in
//                    if let err = err {
//                        fatalError("Ouch: \(err)")
//                    }
//                }
//            }
//            //            self.transitionToHome()
//
//        }
    }
    
    func transitionToHome() {
        
        let homeVC = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
        
        navigationController?.popToViewController(homeVC!, animated: true)
    }
}
