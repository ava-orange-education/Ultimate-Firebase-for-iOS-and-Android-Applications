//
//  SignUpViewController.swift
//  Firebase_Authentication_Begin
//
//  Created by James Thang on 07/01/2024.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crete new Account"
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constant.signUpSuccessSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.signUpSuccessSegue {
            let nextVC = segue.destination
            nextVC.modalPresentationStyle = .fullScreen
        }
    }
}
