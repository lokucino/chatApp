//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by olalekan bisiriyu on 2016-11-01.
//  Copyright © 2016 olalekan bisiriyu. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var backendless = Backendless.sharedInstance()
    
    var newUser: BackendlessUser?
    var email: String?
    var username: String?
    var password: String?
    var avatarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newUser = BackendlessUser()
    }
    

    
    // MARK: - IBActions

    @IBAction func registedButtonPressed(sender: UIButton) {
        
        if emailTextField.text != "" && usernameTextField.text != "" && passwordTextField.text != "" {
            
            email = emailTextField.text
            username = usernameTextField.text
            password = passwordTextField.text
            
            register(self.email!, username: self.username!, password: self.password!, avatarImg: self.avatarImage)
            
        } else {
            
            // warning to the user
        }

    }
    
    // MARK :- Backendless user registration
    func register(email: String, username: String, password: String, avatarImg: UIImage?) {
        
        if avatarImage == nil {
            newUser!.setProperty("Avatar", object: "")
        }
        
        newUser!.email = email
        newUser!.name = username
        newUser!.password = password
        
        backendless.userService.registering(newUser, response: { (registeredUser: BackendlessUser!) in
            
            // login new user
            self.loginUser(email, username: username, password: password)
            
            self.usernameTextField.text = ""
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            
        }) { (fault: Fault!) in
                print("Server reported an error, couldn't register new user: \(fault)")
        }
    }
    
    func loginUser(email: String, username: String, password: String){
        
        backendless.userService.login(email, password: password, response: { (user:BackendlessUser!) in
            
            // here segue to recent vc
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChatVC") as! UITabBarController
            vc.selectedIndex = 0
            self.presentViewController(vc, animated: true, completion: nil)
            

        }) { (fault:Fault!) in
                print("Server reported an error: \(fault)")
        }
        
    }
    
}
