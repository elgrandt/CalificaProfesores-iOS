//
//  ProfessorSummaryInfoController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 15/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import CardParts
import HGCircularSlider

class ProfessorSummaryInfoController: CardsViewController {
    
    var cards: [CardController] = []
    var professor : ProfessorItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if professor == nil || professor!.count! == 0 { return }
        cards = []
        cards.append(ProfessorDataCard(title: "Clases", value: Float(professor!.clases!) / Float(professor!.count!), color: .orange))
        cards.append(ProfessorDataCard(title: "Conocimiento", value: Float(professor!.conocimiento!) / Float(professor!.count!), color: .green))
        cards.append(ProfessorDataCard(title: "Amabilidad", value: Float(professor!.amabilidad!) / Float(professor!.count!), color: .blue))
        self.loadCards(cards: cards)
    }

    func loadProfessor(prof: ProfessorItem) {
        self.professor = prof
    }

}

class ProfessorDataCard: CardPartsViewController, RoundedCardTrait {
    
    var mainView : ProfessorDataCardView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardParts([mainView!])
    }
    
    init(title: String, value: Float, color: UIColor) {
        super.init(nibName: nil, bundle: nil)
        mainView = ProfessorDataCardView(title: title, value: value, color: color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cornerRadius() -> CGFloat {
        return 15.0
    }
}

class ProfessorDataCardView: UIView, CardPartView {
    public var margins: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var slider: CircularSlider!
    
    init(title: String, value: Float, color: UIColor) {
        super.init(frame: CGRect.zero)
        configNib()
        commonInit()
        titleLabel.text = title
        slider.endPointValue = CGFloat(value)
        slider.trackFillColor = color
        slider.maximumValue = 5.05
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configNib()
        commonInit()
    }
    
    func configNib() {
        Bundle.main.loadNibNamed("ProfessorDataView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func commonInit() {
        
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 100)
    }
}
