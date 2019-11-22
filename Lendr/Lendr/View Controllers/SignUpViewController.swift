//
//  SignUpViewController.swift
//  Lendr
//
//  Created by Isaac Lyons on 11/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let networkingController = NetworkingController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func register(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !email.isEmpty,
            !password.isEmpty else {
            return
        }

        let user = SignUpUser(username: username, password: password, email: email)

        networkingController.signUp(user: user) { _, error in
            if error != nil {
                return
            }

            self.performSegue(withIdentifier: "signUpSegue", sender: self)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
