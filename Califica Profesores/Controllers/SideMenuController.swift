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
    
    @IBOutlet weak var userLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.text = currentUser?.displayName
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
    
    @IBAction func jumpView(_ sender: UIButton) {
        var nextView : String?
        
        switch sender.currentTitle {
        case "NOVEDADES":
            nextView = "News"
            break
        case "BUSCAR MATERIA":
            nextView = "BuscarMateria"
            break
        default:
            break
        }
        
        if nextView != nil {
            self.dismiss(animated: true) { () -> Void in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: nextView!)
                UIApplication.shared.keyWindow?.rootViewController = controller
            }
        }
    }
}
