//
//  ProfessorSummaryOpinionsController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 16/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import CardParts
import XLPagerTabStrip

class ProfessorSummaryOpinionsController: CardsViewController, ProfessorOpinionNetwork, IndicatorInfoProvider {
    
    var professor : ProfessorItem?
    
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cards.append(LoadingCard())
        self.loadCards(cards: cards)
        self.getOpinions(profID: professor!.id!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getOpinions(profID: professor!.id!)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "OPINIONES RECIENTES")
    }
    
    func arrivedOpinions(opinions: [OpinionItem]) {
        cards = []
        for op in opinions {
            cards.append(OpinionCard(opinion: op))
        }
        if cards.count == 0 {
            let notFound = NotFoundCard()
            let reviewController = self.storyboard?.instantiateViewController(withIdentifier: "ReviewProfessor") as! ReviewProfessorController
            reviewController.loadProfessor(prof: professor!)
            notFound.mainView?.configure(description: "No hay opiniones", buttonText: "¡SÉ EL PRIMERO!", redirectController: reviewController)
            cards.append(notFound)
        }
        self.reload(cards: cards)
    }
    
    func loadProfessor(professor: ProfessorItem) {
        self.professor = professor
    }
}
