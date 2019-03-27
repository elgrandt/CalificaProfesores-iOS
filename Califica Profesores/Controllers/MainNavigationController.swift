//
//  MainNavigationController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 27/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupNavigationBar(title: String) {
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 27, height: 27)
        menuBtn.setImage(UIImage(named:"Menu"), for: .normal)
        menuBtn.addTarget(self, action: #selector(openMenu), for: UIControl.Event.touchUpInside)

        let button = UIBarButtonItem(customView: menuBtn)
        button.tintColor = .black
        let currWidth = button.customView?.widthAnchor.constraint(equalToConstant: 27)
        currWidth?.isActive = true
        let currHeight = button.customView?.heightAnchor.constraint(equalToConstant: 27)
        currHeight?.isActive = true

        if navigationController?.viewControllers.count == 1 {
            self.navigationItem.leftBarButtonItem = button
        } else {
            self.navigationItem.rightBarButtonItem = button
        }
        
        self.title = title
    }
    
    @objc func openMenu() {
        if let cont = self as? SearchController {
            cont.searchController?.isActive = false
        }
        self.sideMenuController?.revealMenu()
    }
}
