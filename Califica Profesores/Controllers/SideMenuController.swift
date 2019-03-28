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

class SideMenuLayoutController: UIViewController {
    
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.text = currentUser?.displayName
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
