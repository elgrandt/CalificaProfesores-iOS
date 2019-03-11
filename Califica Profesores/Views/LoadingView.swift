//
//  LoadingView.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 04/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import CardParts

class LoadingView: UIView, CardPartView {
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    @IBOutlet var contentView: UIView!
    
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
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 65)
    }
}

class LoadingCard: CardPartsViewController, TransparentCardTrait {
    
    var mainView : LoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardParts([mainView!])
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.mainView = LoadingView(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
