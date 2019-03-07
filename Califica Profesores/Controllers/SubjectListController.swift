//
//  SubjectListController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 06/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import CardParts

class SubjectListController: CardsViewController, UISearchResultsUpdating, SubjectsNetwork {
    
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCards(cards: cards)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchSubjects(keyword: searchController.searchBar.text ?? "")
    }

    func arrivedSubjects(subjects: [SubjectItem]) {
        cards = []
        for s in subjects {
            cards.append(SubjectCard(data: s))
        }
        self.reload(cards: cards)
    }
    
    override func keyboardWillShow(notification: Notification) {
        super.keyboardWillShow(notification: notification)
        collectionView.contentInset.top = CardParts.theme.cardsViewContentInsetTop
    }
}

class SubjectCard: CardPartsViewController, RoundedCardTrait {
    
    var subject = CardPartTextView(type: .normal)
    var separator = CardPartSeparatorView()
    var school = CardPartTextView(type: .normal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subject.font = UIFont(name: "AmericanTypewriter-Bold", size: 19.0)
        school.font = UIFont(name: "ArialMT", size: 12.0)
        setupCardParts([subject, separator, school])
    }
    
    init(data : SubjectItem) {
        super.init(nibName: nil, bundle: nil)
        subject.text = data.ShownName
        school.text = data.FacultadName
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cornerRadius() -> CGFloat {
        return 15.0
    }
}
