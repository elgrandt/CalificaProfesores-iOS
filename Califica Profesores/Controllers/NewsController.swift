//
//  NewsController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 02/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class NewsController: UIViewController, FUIAuthDelegate {

    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAuth()
    }
    
    func jumpView(next : String) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: next)
        self.present(controller!, animated: true, completion: nil)
    }
    
    func configureAuth() {
        // TODO: configure firebase authentication
        let provider: [FUIAuthProvider] = [
            FUIGoogleAuth()
        ]
        FUIAuth.defaultAuthUI()?.providers = provider
        
        // listen for changes in the authorization state
        Auth.auth().addStateDidChangeListener { (auth: Auth, user: User?) in
            
            // check if there is a current user
            if let activeUser = user {
                // check if current app user is the current User
                if self.user != activeUser {
                    // sign in
                }
            } else {
                // user must sign in
                self.loginSession(authUI: FUIAuth(uiWith: auth)!)
            }
        }
    }
    
    private func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            //Error loging in
            print("Error logging in")
            self.loginSession(authUI: authUI)
            return
        }
        print("Sign in successful")
    }
    
    func loginSession(authUI: FUIAuth) {
        let authViewController = LoginController(nibName: "LoginView", bundle: Bundle.main, authUI: authUI)
        self.present(authViewController, animated: false, completion: nil)
    }

    @IBAction func logout(_ sender: UIButton) {
        try! Auth.auth().signOut()
    }
}
