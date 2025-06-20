//
//  ViewController.swift
//  Firebase_Authentication_Begin
//
//  Created by James Thang on 06/01/2024.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func logInPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constant.logInSuccessSegue, sender: self)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func continueWithGooglePressed(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.logInSuccessSegue {
            let nextVC = segue.destination 
            nextVC.modalPresentationStyle = .fullScreen
        }
    }
}

