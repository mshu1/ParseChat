//
//  LoginViewController.swift
//  Parse Chat
//
//  Created by Michelle Shu on 2/23/17.
//  Copyright © 2017 Michelle Shu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickSignup(_ sender: AnyObject) {
        let email = emailField.text
        let password = passwordField.text
        
        let user = PFUser()
        user.username = email
        user.email = email
        user.password = password
        
        user.signUpInBackground {
            (succeeded: Bool, error: Error?) -> Void in
            if let error = error {
//                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print(error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "signupSegue", sender: nil)
            }
        }
    }

    @IBAction func onClickLogin(_ sender: Any) {
        let email = emailField.text
        let password = passwordField.text
        
        let user = PFUser()
        user.username = email
        user.email = email
        user.password = password
        
        PFUser.logInWithUsername(inBackground: email!, password: password!) { (user: PFUser?, error: Error?) in
            if ((user) != nil) {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
