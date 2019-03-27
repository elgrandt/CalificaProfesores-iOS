//
//  NewsController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 02/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import CardParts

class NewsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar(title: "Noticias")
    }
    
}

class NewsCardsController: CardsViewController, NewsNetwork {
    
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startGettingNews()
        self.cards.append(LoadingCard())
        self.loadCards(cards: cards)
    }
    
    func arrivedNews(news: [NewsItem]) {
        cards = []
        for new in news {
            cards.append(NewsCard(new: new))
        }
        cards = cards.reversed()
        self.reload(cards: cards)
    }
}

class NewsCard: CardPartsViewController, RoundedCardTrait {
    
    var contentView : NewsCardView?
    var separator = CardPartSeparatorView()
    var time = CardPartTextView(type: .normal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        time.textAlignment = .right
        setupCardParts([contentView!, separator, time])
    }
    
    init(new : NewsItem) {
        super.init(nibName: nil, bundle: nil)
        contentView = NewsCardView(title: new.title!, content: new.content!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss" //Specify your format that you want
        time.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(new.timestamp!/1000)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cornerRadius() -> CGFloat {
        return 15.0
    }
}

public class NewsCardView: UIView, CardPartView {
    public var margins: UIEdgeInsets = CardParts.theme.cardPartMargins

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UITextView!
    
    var altura : CGFloat?
    
    public init(title : String, content: String) {
        super.init(frame: CGRect.zero)
        configNib()
        commonInit()
        self.title.text = title
        self.desc.text = content
        self.desc.sizeToFit()
        altura = self.title.frame.height + desc.contentSize.height
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configNib()
        commonInit()
    }
    
    func configNib() {
        Bundle.main.loadNibNamed("NewsCardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func commonInit() {
        desc.isEditable = false
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: altura!)
    }
}
