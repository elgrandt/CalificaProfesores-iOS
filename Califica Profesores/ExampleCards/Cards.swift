//
//  Cards.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 05/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//
import UIKit
import CardParts

// Android : Adapter
class MyCardsViewController: CardsViewController {
    
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 1...100 {
            cards.append(CardPartButtonViewCardController())
        }
        loadCards(cards: cards)
    }
}

// Android: View holder
class CardPartButtonViewCardController: CardPartsViewController, RoundedCardTrait {
    
    let cardPartTextView = CardPartTextView(type: .normal)
    let cardPartTextView2 = CardPartTextView(type: .normal)
    let customView = CustomCardView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTextView.text = "This is a CardPartButtonView"
        cardPartTextView2.text = "This is a CardPartButtonView 2"
        
        setupCardParts([cardPartTextView, cardPartTextView2, customView])
    }
    
    func cornerRadius() -> CGFloat {
        return 15.0
    }
}

public class CustomCardView: UIView, CardPartView {
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    @IBOutlet var contentView: UIView!
    
    public init() {
        super.init(frame: CGRect.zero)
        configNib()
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configNib()
        commonInit()
    }
    
    func configNib() {
        Bundle.main.loadNibNamed("TestCustomCardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func commonInit() {
        self.backgroundColor = .red
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 150)
    }
}
