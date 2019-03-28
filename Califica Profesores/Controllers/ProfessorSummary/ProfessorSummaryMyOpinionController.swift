//
//  ProfessorSummaryMyOpinionController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 17/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ProfessorSummaryMyOpinionController: UIViewController, IndicatorInfoProvider, ProfessorOpinionNetwork {
    
    var professor : ProfessorItem?
    var opinion : OpinionItem?
    @IBOutlet weak var loading: LoadingView!
    @IBOutlet weak var myOpinionCard: OpinionCardView!
    @IBOutlet weak var noOpinionText: UILabel!
    @IBOutlet weak var myOpinionCardHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loading.isHidden = false
        myOpinionCard.isHidden = true
        noOpinionText.isHidden = true
        myOpinionCard.layer.cornerRadius = 15.0
        self.getOpinions(profID: professor!.id!, userUID: currentUser?.uid)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TU OPINIÓN")
    }
    
    func loadProfessor(professor: ProfessorItem) {
        self.professor = professor
    }
    
    func arrivedOpinions(opinions: [OpinionItem]) {
        loading.isHidden = true
        if opinions.count > 0 {
            myOpinionCard.isHidden = false
            myOpinionCard.commonInit(op: opinions.first!)
            myOpinionCardHeight.constant = myOpinionCard.intrinsicContentSize.height
            reviewButton.setTitle("CAMBIAR OPINIÓN", for: .normal)
            opinion = opinions.first
        } else {
            noOpinionText.isHidden = false
            reviewButton.setTitle("OPINAR", for: .normal)
        }
    }

    @IBAction func reviewProfessor(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReviewProfessor") as! ReviewProfessorController
        controller.loadProfessor(prof: professor!)
        if opinion != nil {
            controller.loadOpinion(op: opinion!)
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
