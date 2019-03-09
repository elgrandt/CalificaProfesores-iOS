//
//  SubjectSummaryOpinionsController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 08/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import CardParts
import Cosmos
import XLPagerTabStrip

class SubjectSummaryOpinionsController: CardsViewController, SubjectOpinionNetwork, IndicatorInfoProvider {
    
    var subject: SubjectItem?
    
    var cards: [CardController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCards(cards: cards)
        self.getOpinions(subjectID: subject!.id!)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "OPINIONES RECIENTES")
    }
    
    func loadSubject(subject: SubjectItem) {
        self.subject = subject
    }
    
    func arrivedOpinions(opinions: [OpinionItem]) {
        for op in opinions {
            cards.append(OpinionCard(opinion: op))
        }
        self.reload(cards: cards)
    }
    
}

class OpinionCard : CardPartsViewController, RoundedCardTrait, NoTopBottomMarginsCardTrait {
    
    var mainView : OpinionCardView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardParts([mainView!])
    }
    
    init(opinion: OpinionItem) {
        super.init(nibName: nil, bundle: nil)
        mainView = OpinionCardView(opinion: opinion)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cornerRadius() -> CGFloat {
        return 15.0
    }
}

public class OpinionCardView: UIView, CardPartView {
    public var margins: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var score: CosmosView!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    
    init(opinion: OpinionItem) {
        super.init(frame: CGRect.zero)
        configNib()
        commonInit()
        nameLabel.text = opinion.author
        score.rating = Double(opinion.valoracion!)/2.0
        content.text = opinion.content!
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss" //Specify your format that you want
        timeLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(opinion.timestamp!/1000)))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configNib()
        commonInit()
    }
    
    func configNib() {
        Bundle.main.loadNibNamed("OpinionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = 15.0
    }
    
    func commonInit() {
        leftView.layer.cornerRadius = 15.0
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 80 + content.contentSize.height)
    }
}
