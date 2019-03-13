//
//  HeaderView.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 04/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import SideMenu

class HeaderView: UIView {
    
    @IBOutlet var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configNib()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configNib()
        commonInit()
    }
    
    func configNib() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func commonInit() {
        
    }
    
    public func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
        
    }

    @IBAction func openMenu(_ sender: Any) {
        let vc: UIViewController? = SideMenuManager.default.menuLeftNavigationController!
        let currentController = self.getCurrentViewController()
        currentController?.present(vc!, animated: true, completion: nil)
    }
}
