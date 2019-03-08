//
//  SubjectProfessorListController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 08/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import CardParts

class ProfessorListController: CardsViewController, ProfessorsNetwork {
    
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCards(cards: cards)
    }
    
    func loadProfessors(professors: [String]) {
        cards = []
        for x in professors {
            self.searchProfessor(hash: x)
        }
    }
    
    func arrivedProfessor(professor: ProfessorItem) {
        cards.append(ProfessorInfoCard(data: professor))
        self.reload(cards: cards)
    }

}

class ProfessorInfoCard: CardPartsViewController, RoundedCardTrait {
    
    var mainView : ProfessorInfoCardView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardParts([mainView!])
    }
    
    init(data : ProfessorItem) {
        super.init(nibName: nil, bundle: nil)
        mainView = ProfessorInfoCardView(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cornerRadius() -> CGFloat {
        return 15.0
    }
}

public class ProfessorInfoCardView: UIView, CardPartView {
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins
    var professor : ProfessorItem?
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    init(data: ProfessorItem) {
        super.init(frame: CGRect.zero)
        configNib()
        commonInit()
        self.professor = data
        self.nameLabel.text = data.Name
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configNib()
        commonInit()
    }
    
    func configNib() {
        Bundle.main.loadNibNamed("ProfessorInfoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func commonInit() {
        self.backgroundColor = .red
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 60)
    }
}
