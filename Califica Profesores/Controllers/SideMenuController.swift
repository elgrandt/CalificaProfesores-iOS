//
//  SideMenuController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 04/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class SideMenuLayoutController: UIViewController {
    
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userLabel.text = currentUser?.displayName
        if userLabel.text == nil && currentUser?.email != nil {
            userLabel.text = String(currentUser!.email!.prefix(while: {c in
                return c != "@"
            })).capitalized
        }
    }
    
    func jumpView(next : String, animated : Bool = true) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: next)
        self.present(controller!, animated: animated, completion: nil)
    }

    @IBAction func logout(_ sender: Any) {
        // Facebook
        let LoginManager = FBSDKLoginManager()
        LoginManager.logOut()
        // Google
        GIDSignIn.sharedInstance()?.signOut()
        // Firebase
        try! Auth.auth().signOut()
        // Redirect
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        UIApplication.shared.keyWindow?.rootViewController = controller
    }
    
    @IBAction func jumpView(_ sender: UIButton) {
        var nextView : String?
        var storyboardName = "Main"
        
        switch sender.currentTitle {
        case "NOVEDADES":
            nextView = "NewsNC"
            break
        case "BUSCAR MATERIA":
            nextView = "SearchSubjectsNC"
            storyboardName = "Subjects"
            break
        case "BUSCAR PROFESOR":
            nextView = "SearchProfessorsNC"
            storyboardName = "Professors"
            break
        case "CAMBIAR FACULTAD":
            nextView = "SearchSchoolsNC"
            storyboardName = "Subjects"
            break
        case "Atribuciones":
            nextView = "AttributionsNC"
            break
        case "Politica de Privacidad":
            nextView = "PrivacyNC"
            break
        default:
            break
        }
        
        if nextView != nil {
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: nextView!)
            sideMenuController?.setContentViewController(to: controller)
            sideMenuController?.hideMenu()
        }
    }
}
