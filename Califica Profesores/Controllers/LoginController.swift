//
//  LoginController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 02/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class LoginController: FUIAuthPickerViewController {
    @IBOutlet var contentView: UIView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, authUI: FUIAuth) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil, authUI: authUI)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
