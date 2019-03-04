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
import SideMenu

class NewsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuParallaxStrength = 10
        SideMenuManager.default.menuWidth = max(round(min((UIScreen.main.bounds.width), (UIScreen.main.bounds.height)) * 0.80), 240)
    }
}
