//
//  SignUpViewController.swift
//  Firebase_Authentication_Begin
//
//  Created by James Thang on 07/01/2024.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crete new Account"
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTextFieldState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
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
        
        // Check if the passwords match
        if password != confirmPassword {
            // Show error: Passwords do not match
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let weakSelf = self else { return }
            if let error = error {
                // Handle error: Show error message
                print(error.localizedDescription)
                return
            }
            weakSelf.performSegue(withIdentifier: Constant.signUpSuccessSegue, sender: weakSelf)
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
        confirmPasswordTextField.text = ""
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
}
