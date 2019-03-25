//
//  SelectorView.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 23/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import CardParts

class SelectorViewListController: CardsViewController {
    
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 2
        self.collectionView.backgroundColor = .white
        collectionView.contentInset.top = 2
        collectionView.contentInset.bottom = 2
        loadCards(cards: cards)
    }
    
    func update(cards: [CardController]) {
        self.cards = cards
        reload(cards: self.cards)
    }
    
    override func keyboardWillShow(notification: Notification) {
        super.keyboardWillShow(notification: notification)
        collectionView.contentInset.top = 2
        collectionView.contentInset.bottom = 2
    }
}

protocol SelectorCardDelegate {
    func selectedCard(card: SelectorCard)
}

class SelectorCard: CardPartsViewController, RoundedCardTrait, NoTopBottomMarginsCardTrait {
    
    var mainView : SelectorCardView?
    var delegate : SelectorCardDelegate?
    var id : String?
    var tit : String?
    var desc : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardParts([mainView!])
        self.cardTapped {
            self.delegate?.selectedCard(card: self)
        }
    }
    
    init(title: String, description: String, id: String, delegate: SelectorCardDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        mainView = SelectorCardView(title: title, description: description)
        self.id = id
        self.tit = title
        self.desc = description
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cornerRadius() -> CGFloat {
        return 5.0
    }
}

class SelectorCardView: UIView, CardPartView {
    public var margins: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    init(title: String, description: String) {
        super.init(frame: CGRect.zero)
        configNib()
        commonInit()
        self.title.text = title
        self.desc.text = description
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configNib()
        commonInit()
    }
    
    func configNib() {
        Bundle.main.loadNibNamed("SelectorCardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func commonInit() {
        
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 40)
    }
}
