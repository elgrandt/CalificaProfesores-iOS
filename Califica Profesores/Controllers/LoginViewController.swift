//
//  LoginViewController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 04/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import SideMenuSwift

var currentUser : User?

class LoginViewController: UIViewController, FUIAuthDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAuth()
    }
    
    func jumpView(next : String, animated : Bool = true) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: next)
        self.present(controller!, animated: animated, completion: nil)
    }
    
    func configureAuth() {
        // TODO: configure firebase authentication
    
        let provider: [FUIAuthProvider] = [
            FUIGoogleAuth()
        ]
        FUIAuth.defaultAuthUI()?.delegate = self
        FUIAuth.defaultAuthUI()?.providers = provider
        
        // listen for changes in the authorization state
        Auth.auth().addStateDidChangeListener { (auth: Auth, user: User?) in
            
            // check if there is a current user
            if user != nil {
                // check if current app user is the current User
                currentUser = user
                let news = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "News")
                self.sideMenuController?.setContentViewController(to: news)
            } else {
                // user must sign in
                self.loginSession(authUI: FUIAuth(uiWith: auth)!)
            }
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, url: URL?, error: Error?) {
        if error != nil {
            //Error loging in
            print("Error logging in")
            self.loginSession(authUI: authUI)
            return
        }
        print("Sign in successful")
        currentUser = authDataResult?.user
        
        let news = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "News")
        self.sideMenuController?.setContentViewController(to: news)
    }
    
    func loginSession(authUI: FUIAuth) {
        let authViewController = LoginController(nibName: "LoginView", bundle: Bundle.main, authUI: authUI)
        self.present(authViewController, animated: false, completion: nil)
    }

}
