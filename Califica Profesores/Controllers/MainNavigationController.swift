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

        let rightButton = UIBarButtonItem(customView: menuBtn)
        rightButton.tintColor = .black
        let currWidth = rightButton.customView?.widthAnchor.constraint(equalToConstant: 27)
        currWidth?.isActive = true
        let currHeight = rightButton.customView?.heightAnchor.constraint(equalToConstant: 27)
        currHeight?.isActive = true

        self.navigationItem.rightBarButtonItem = rightButton
        self.title = title
    }
    
    @objc func openMenu() {
        self.sideMenuController?.revealMenu()
    }
}
