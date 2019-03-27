//
//  SubjectSearchController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 06/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import CardParts
import XLPagerTabStrip

protocol SearchController {
    var searchController : UISearchController? {get set}
}

class SubjectSearchController: UIViewController, SearchController {
    var searchController : UISearchController?
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var schoolView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar(title: "Buscar")
        let controller = self.children.first as! SubjectListController
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.placeholder = "Buscar Materia"
        searchController?.searchResultsUpdater = controller
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        searchBarContainer.addSubview((searchController?.searchBar)!)
        let school = UserDefaults.standard.string(forKey: "SCHOOL_NAME")
        if school == nil {
            schoolLabel.text = "Todas las facultades"
        } else {
            schoolLabel.text = school?.uppercased()
        }
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.changeSchool (_:)))
        schoolView.addGestureRecognizer(gesture)
    }
    
    @objc func changeSchool(_ sender:UITapGestureRecognizer) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "BuscarFacultad")
        UIApplication.shared.keyWindow?.rootViewController = controller
    }
}

class SubjectListController: CardsViewController, UISearchResultsUpdating, SubjectsNetwork {
    
    var cards: [CardController] = []
    let notFoundCard = NotFoundCard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let subjectCreator = self.storyboard?.instantiateViewController(withIdentifier: "SubjectCreator") as? SubjectCreator
        notFoundCard.mainView?.configure(description: "¿No encontraste lo que buscabas?", buttonText: "AGREGAR NUEVA MATERIA", redirectController: subjectCreator!)
        cards.append(notFoundCard)
        loadCards(cards: cards)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let school = UserDefaults.standard.string(forKey: "SCHOOL_ID")
        self.searchSubjects(keyword: searchController.searchBar.text ?? "", school: school)
    }
    
    func arrivedSubjects(subjects: [SubjectItem]) {
        cards = []
        for s in subjects {
            let card = SubjectCard(data: s)
            cards.append(card)
        }
        cards.append(notFoundCard)
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
            let board = UIStoryboard(name: "Subjects", bundle: nil)
            let controller = board.instantiateViewController(withIdentifier: "SubjectSummary") as! SubjectSummaryPager
            controller.loadSubject(subject: self.data!)
            let searchController = self.parent?.parent as? SubjectSearchController
            searchController?.searchController?.isActive = false
            self.navigationController?.pushViewController(controller, animated: true)
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
