//
//  LoadingView.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 04/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    @IBOutlet var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configNib()
    }
    
    func configNib() {
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
