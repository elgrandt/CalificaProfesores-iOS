//
//  ProfessorSearchController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 13/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import CardParts

class ProfessorSearchController: UIViewController, SearchController {
    var searchController : UISearchController?
    @IBOutlet weak var searchBarContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let controller = self.children.first as! ProfessorListController
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.placeholder = "Buscar Profesor"
        searchController?.searchResultsUpdater = controller
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        searchBarContainer.addSubview((searchController?.searchBar)!)
    }
}

class ProfessorListController: CardsViewController, UISearchResultsUpdating, ProfessorListNetwork {
    
    var cards: [CardController] = []
    let notFoundCard = NotFoundCard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let professorCreator = self.storyboard?.instantiateViewController(withIdentifier: "ProfessorCreator") as? ProfessorCreator
        notFoundCard.mainView?.configure(description: "¿No encontraste lo que buscabas?", buttonText: "AGREGAR NUEVO PROFESOR", redirectController: professorCreator!)
        cards.append(notFoundCard)
        loadCards(cards: cards)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchProfessors(keyword: searchController.searchBar.text ?? "")
    }
    
    func arrivedProfessors(professors: [ProfessorItem]) {
        cards = []
        for p in professors {
            cards.append(ProfessorCard(data: p))
        }
        cards.append(notFoundCard)
        self.reload(cards: cards)
    }
    
    override func keyboardWillShow(notification: Notification) {
        super.keyboardWillShow(notification: notification)
        collectionView.contentInset.top = CardParts.theme.cardsViewContentInsetTop
    }
    
}

class ProfessorCard: CardPartsViewController, RoundedCardTrait {
    
    var professor = CardPartTextView(type: .normal)
    var separator = CardPartSeparatorView()
    var school = CardPartTextView(type: .normal)
    var data : ProfessorItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        professor.font = UIFont(name: "AmericanTypewriter-Bold", size: 19.0)
        school.font = UIFont(name: "ArialMT", size: 12.0)
        setupCardParts([professor, separator, school])
        self.cardTapped {
            let board = UIStoryboard(name: "Professors", bundle: nil)
            let controller = board.instantiateViewController(withIdentifier: "ProfessorSummary") as! ProfessorSummaryPager
            controller.loadProfessor(professor: self.data!)
            let searchController = self.parent?.parent as? ProfessorSearchController
            searchController?.searchController?.isActive = false
            self.present(controller, animated: false, completion: nil)
        }
    }
    
    init(data : ProfessorItem) {
        super.init(nibName: nil, bundle: nil)
        professor.text = data.Name
        school.text = data.Facultades.values.joined(separator: ", ")
        if school.text == nil || school.text == "" {
            school.text = "Sin facultades asignadas"
        }
        self.data = data
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cornerRadius() -> CGFloat {
        return 15.0
    }
    
}
