//
//  ViewController.swift
//  Firebase_Authentication_Begin
//
//  Created by James Thang on 06/01/2024.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private var isLogInProcess = false
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTextFieldState()
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let weakSelf = self else { return }
            if weakSelf.isLogInProcess { return }
            if user != nil {
                weakSelf.performSegue(withIdentifier: Constant.logInSuccessSegue, sender: weakSelf)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func logInPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // Show error: All fields must be filled
            return
        }
        
        // Check if the email is valid
        if !isValidEmail(email) {
            // Show error: Invalid email
            return
        }
        
        // Check if the password is at least 6 characters
        if password.count < 6 {
            // Show error: Password too short
            return
        }
        
        isLogInProcess = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let weakSelf = self else { return }
            weakSelf.isLogInProcess = false
            if let error = error {
                // Handle error: Show error message
                print(error.localizedDescription)
                return
            }
            weakSelf.performSegue(withIdentifier: Constant.logInSuccessSegue, sender: weakSelf)
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constant.signUpScreen, sender: self)
    }
    
    @IBAction func continueWithGooglePressed(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else { return }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            isLogInProcess = true
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                guard let weakSelf = self else { return }
                weakSelf.isLogInProcess = false
                if let error = error {
                    // Handle error: Show error message
                    print(error.localizedDescription)
                    return
                }
                weakSelf.performSegue(withIdentifier: Constant.logInSuccessSegue, sender: weakSelf)
            }
        }
    }
    
    // Helper method to validate email format
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func resetTextFieldState() {
        emailTextField.text = ""
        passwordTextField.text = ""
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
