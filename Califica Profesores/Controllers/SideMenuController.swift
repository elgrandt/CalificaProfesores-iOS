//
//  SideMenuController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 04/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class SideMenuController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func jumpView(next : String, animated : Bool = true) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: next)
        self.present(controller!, animated: animated, completion: nil)
    }

    @IBAction func logout(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: true) { () -> Void in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            UIApplication.shared.keyWindow?.rootViewController = controller
        }
        
    }
}
