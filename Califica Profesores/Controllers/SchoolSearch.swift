//
//  SchoolSearch.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 26/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import CardParts

class SchoolSearchController: UIViewController, SearchController {
    var searchController : UISearchController?
    @IBOutlet weak var searchBarContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar(title: "Buscar")
        let controller = self.children.first as! SchoolListController
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.placeholder = "Buscar Facultad"
        searchController?.searchResultsUpdater = controller
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        searchBarContainer.addSubview((searchController?.searchBar)!)
    }
}

class SchoolListController: CardsViewController, UISearchResultsUpdating, SchoolNetwork {
    
    var cards: [CardController] = []
    let notFoundCard = NotFoundCard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let schoolCreator = self.storyboard?.instantiateViewController(withIdentifier: "SchoolCreator") as? SchoolCreator
        notFoundCard.mainView?.configure(description: "¿No encontraste lo que buscabas?", buttonText: "AGREGAR NUEVA FACULTAD", redirectController: schoolCreator!)
        cards.append(notFoundCard)
        loadCards(cards: cards)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchSchools(keyword: searchController.searchBar.text ?? "")
    }
    
    func arrivedSchools(schools: [SchoolItem]) {
        cards = []
        let allSchools = SchoolItem()
        allSchools.Name = "Todas las facultades"
        allSchools.ShownName = "Buscar en todas las facultades"
        cards.append(SchoolCard(data: allSchools))
        for s in schools {
            cards.append(SchoolCard(data: s))
        }
        cards.append(notFoundCard)
        self.reload(cards: cards)
    }
    
    override func keyboardWillShow(notification: Notification) {
        super.keyboardWillShow(notification: notification)
        collectionView.contentInset.top = CardParts.theme.cardsViewContentInsetTop
    }
    
}

class SchoolCard: CardPartsViewController, RoundedCardTrait {
    
    var name = CardPartTextView(type: .normal)
    var separator = CardPartSeparatorView()
    var shownName = CardPartTextView(type: .normal)
    var data : SchoolItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.font = UIFont(name: "AmericanTypewriter-Bold", size: 19.0)
        shownName.font = UIFont(name: "ArialMT", size: 12.0)
        setupCardParts([name, separator, shownName])
        self.cardTapped {
            if self.data?.id != nil {
                UserDefaults.standard.set(self.data?.Name, forKey: "SCHOOL_NAME")
                UserDefaults.standard.set(self.data?.id, forKey: "SCHOOL_ID")
            } else {
                UserDefaults.standard.set(nil, forKey: "SCHOOL_NAME")
                UserDefaults.standard.set(nil, forKey: "SCHOOL_ID")
            }
            let controller = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "SearchSubjectsNC")
            let searchController = self.parent?.parent as? SearchController
            searchController?.searchController?.isActive = false
            self.sideMenuController?.setContentViewController(to: controller)
        }
    }
    
    init(data : SchoolItem) {
        super.init(nibName: nil, bundle: nil)
        name.text = data.Name?.uppercased()
        shownName.text = data.ShownName
        self.data = data
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cornerRadius() -> CGFloat {
        return 15.0
    }
    
}
