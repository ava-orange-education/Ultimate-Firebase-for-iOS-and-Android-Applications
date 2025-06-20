//
//  SettingViewController.swift
//  Firebase_Authentication_Begin
//
//  Created by James Thang on 07/01/2024.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account Setting"
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
  
    @IBAction func deleteAccountPressed(_ sender: UIButton) {
        if let provider = getUserAuthenProvider() {
            switch provider {
            case .google:
                deleteGoogleUser()
            case .password:
                deleteEmailUser()
            }
        }
    }
    
    enum AuthenticationProvider: String {
        case google
        case password
    }
    
    private func getUserAuthenProvider() -> AuthenticationProvider? {
        if let currentUser = Auth.auth().currentUser {
            for userInfo in currentUser.providerData {
                switch userInfo.providerID {
                case "google.com":
                    return .google
                case "password":
                    return .password
                default:
                    return nil
                }
            }
        }
        return nil
    }
    
    private func deleteEmailUser() {
        let alertController = UIAlertController(title: "Are you sure to delete this account?", message: "Please enter your email and password to continue.", preferredStyle: .alert)
        
        // Add email text field
        alertController.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
        }
        
        // Add password text field
        alertController.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            textField.autocapitalizationType = .none
        }
        
        // Add Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add Delete button with a destructive style
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let emailField = alertController.textFields?.first,
                  let passwordField = alertController.textFields?.last,
                  let email = emailField.text,
                  let password = passwordField.text else { return }
            
            // Perform reauthentication here with the provided email and password
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            self?.reauthenticateWithFirebase(credential: credential)
        }
        
        // Add actions to the alert controller
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        // Present the alert
        self.present(alertController, animated: true)
    }
    
    private func deleteGoogleUser() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else { return }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            // Proceed to reauthenticate with the obtained credential
            reauthenticateWithFirebase(credential: credential)
        }
    }
    
    private func reauthenticateWithFirebase(credential: AuthCredential) {
        let currentUser = Auth.auth().currentUser
        currentUser?.reauthenticate(with: credential) { [weak self] authResult, error in
            if let error = error {
                // Handle error
                print("Reauthentication failed: \(error.localizedDescription)")
                return
            }
            // User reauthenticated successfully
            // Proceed delete account
            self?.deleteUser()
        }
    }
    
    private func deleteUser() {
        let user = Auth.auth().currentUser
        user?.delete { [weak self] error in
            guard let weakSelf = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else {
                weakSelf.navigationController?.popToRootViewController(animated: false)
            }
        }
    }
    
}


