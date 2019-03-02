//
//  LoginController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 02/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
    }
    
    func jumpView(current : String, next : String) {
        let storyboard = UIStoryboard(name: current, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: next)
        self.present(controller, animated: true, completion: nil)
    }

}
