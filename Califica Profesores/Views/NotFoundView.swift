//
//  NotFoundView.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 12/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import CardParts

class NotFoundView: UIView, CardPartView {
    public var margins: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var redirectButton: UIButton!
    var redirectController : UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configNib()
        contentView.layer.cornerRadius = 15.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configNib()
    }
    
    func configure(description: String, buttonText: String, redirectController: UIViewController) {
        self.redirectController = redirectController
        descriptionLabel.text = description
        redirectButton.setTitle(buttonText, for: .normal)
    }
    
    func configNib() {
        Bundle.main.loadNibNamed("NotFoundView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 187)
    }
    
    @IBAction func redirect(_ sender: Any) {
        let currentController = HeaderView().getCurrentViewController()
        if redirectController != nil {
            currentController?.present(redirectController!, animated: true, completion: nil)
        }
    }
}


class NotFoundCard: CardPartsViewController, RoundedCardTrait, NoTopBottomMarginsCardTrait {
    
    var mainView : NotFoundView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardParts([mainView!])
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.mainView = NotFoundView(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cornerRadius() -> CGFloat {
        return 15.0
    }
}
