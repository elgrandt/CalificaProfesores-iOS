//
//  Documentation.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 27/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import CardParts

class Attributions: CardsViewController, DocumentationNetwork {
    
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar(title: "Atribuciones")
        self.getAttributions()
        self.loadCards(cards: cards)
    }
    
    func arrivedResults(results: [String]) {
        for res in results {
            cards.append(DocumentationCard(html: res))
        }
        reload(cards: cards)
    }
}

class PrivacyPolicies: CardsViewController, DocumentationNetwork {
    
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar(title: "Política de Privacidad")
        self.getPrivacyPolicies()
        self.loadCards(cards: cards)
    }
    
    func arrivedResults(results: [String]) {
        for res in results {
            cards.append(DocumentationCard(html: res))
        }
        reload(cards: cards)
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
}

class DocumentationCard: CardPartsViewController, RoundedCardTrait {
    
    var text = CardPartTextView(type: .normal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardParts([text])
    }
    
    init(html: String) {
        super.init(nibName: nil, bundle: nil)
        text.attributedText = html.html2AttributedString
        text.text = html
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cornerRadius() -> CGFloat {
        return 15.0
    }
}
