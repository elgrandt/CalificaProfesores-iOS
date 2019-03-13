//
//  SubjectSubjectProfessorListController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 08/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import CardParts
import LinearProgressView
import Cosmos

class SubjectProfessorListController: CardsViewController, ProfessorsNetwork {
    
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cards.append(LoadingCard())
        self.loadCards(cards: cards)
    }
    
    func loadProfessors(professors: [String]) {
        cards = []
        for x in professors {
            self.searchProfessor(hash: x)
        }
        if professors.isEmpty {
            let noProfessorsCard = NotFoundCard()
            noProfessorsCard.mainView?.configure(description: "No hay información de profesores", buttonText: "AGREGAR PROFESOR", redirectController: UIViewController())
            cards.append(noProfessorsCard)
        }
        self.reload(cards: cards)
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
    @IBOutlet weak var rankStars: CosmosView!
    @IBOutlet weak var lessonsBar: LinearProgressView!
    @IBOutlet weak var knowledgeBar: LinearProgressView!
    @IBOutlet weak var amabilityBar: LinearProgressView!
    
    init(data: ProfessorItem) {
        super.init(frame: CGRect.zero)
        configNib()
        commonInit()
        self.professor = data
        self.nameLabel.text = data.Name
        if (professor!.count! != 0) {
            rankStars.rating = Double(professor!.amabilidad! + professor!.clases! + professor!.conocimiento!) / (3.0*Double(professor!.count!))
            lessonsBar.setProgress(Float(professor!.clases!)/Float(professor!.count!), animated: true)
            knowledgeBar.setProgress(Float(professor!.conocimiento!)/Float(professor!.count!), animated: true)
            amabilityBar.setProgress(Float(professor!.amabilidad!)/Float(professor!.count!), animated: true)
        }
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
        
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 65)
    }
}
