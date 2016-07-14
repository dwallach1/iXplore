//
//  LoginViewController.swift
//  iXplore
//
//  Created by David Wallach on 7/13/16.
//  Copyright © 2016 David Wallach. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is already logged in, do work such as go to next view controller.
        } else {
            let loginButton = FBSDKLoginButton()
            loginButton.center = view.center 
            view.addSubview(loginButton)
            self.title = "Login To iXplore"
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                let MapVC = MapViewController(nibName: "MapViewController", bundle: nil)
                presentViewController(MapVC, animated: true, completion: nil)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
