//
//  LoginViewController.swift
//  ChatApp
//
//  Created by olalekan bisiriyu on 2016-11-01.
//  Copyright © 2016 olalekan bisiriyu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let backendless = Backendless.sharedInstance()
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    

    
    // MARK: - IBActions

    @IBAction func loginBarButtonItemPressed(sender: UIBarButtonItem) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            self.email = emailTextField.text
            self.password = passwordTextField.text
            
            // login user
            loginUser(email!, password: password!)
        } else {
            // show error to user
        }
    }
 
    func loginUser(email: String, password: String)  {
        backendless.userService.login(email, password: password, response: { (user:BackendlessUser!) in
            
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            
            // segue to recents view
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChatVC") as! UITabBarController
            vc.selectedIndex = 0
            self.presentViewController(vc, animated: true, completion: nil)
            
            
            print("login")
        }) { (fault:Fault!) in
                print("Couldn't login user \(fault)")
        }
    }

}
