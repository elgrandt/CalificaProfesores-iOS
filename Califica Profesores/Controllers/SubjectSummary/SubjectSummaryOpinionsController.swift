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
        cards.append(LoadingCard())
        self.loadCards(cards: cards)
        self.getOpinions(subjectID: subject!.id!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getOpinions(subjectID: subject!.id!)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "OPINIONES RECIENTES")
    }
    
    func loadSubject(subject: SubjectItem) {
        self.subject = subject
    }
    
    func arrivedOpinions(opinions: [OpinionItem]) {
        cards = []
        for op in opinions {
            cards.append(OpinionCard(opinion: op))
        }
        if cards.count == 0 {
            let notFound = NotFoundCard()
            let reviewController = storyboard!.instantiateViewController(withIdentifier: "ReviewSubject") as! ReviewSubjectController
            reviewController.loadSubject(subj: self.subject!)
            notFound.mainView?.configure(description: "No hay opiniones", buttonText: "¡SÉ EL PRIMERO!", redirectController: reviewController)
            cards.append(notFound)
        }
        self.reload(cards: cards)
    }
    
}
