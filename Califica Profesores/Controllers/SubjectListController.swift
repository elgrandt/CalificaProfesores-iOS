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
    var data : SubjectItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subject.font = UIFont(name: "AmericanTypewriter-Bold", size: 19.0)
        school.font = UIFont(name: "ArialMT", size: 12.0)
        setupCardParts([subject, separator, school])
        self.cardTapped {
            let board = UIStoryboard(name: "Main", bundle: nil)
            let controller = board.instantiateViewController(withIdentifier: "SubjectSummary") as! UITabBarController
            let generalSection = controller.children[0] as! SubjectSummaryGeneralController
            generalSection.subject = self.data
            self.dismiss(animated: false, completion: {
                self.present(controller, animated: true, completion: nil)
            })
        }
    }
    
    init(data : SubjectItem) {
        super.init(nibName: nil, bundle: nil)
        subject.text = data.ShownName
        school.text = data.FacultadName
        self.data = data
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cornerRadius() -> CGFloat {
        return 15.0
    }

}
