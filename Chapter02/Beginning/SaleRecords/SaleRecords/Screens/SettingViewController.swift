//
//  SettingViewController.swift
//  Firebase_Authentication_Begin
//
//  Created by James Thang on 07/01/2024.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account Setting"
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func deleteAccountPressed(_ sender: UIButton) {
    }
}
