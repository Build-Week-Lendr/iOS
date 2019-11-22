//
//  SignInViewController.swift
//  Lendr
//
//  Created by Isaac Lyons on 11/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signIn(_ sender: UIButton) {
        guard let password = passwordTextField.text,
            !password.isEmpty else { return }

        NetworkingController.signIn(token: password)
        self.performSegue(withIdentifier: "signInSegue", sender: self)
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
