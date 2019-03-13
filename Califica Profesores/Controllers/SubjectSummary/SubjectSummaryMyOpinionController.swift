//
//  SubjectSummaryMyOpinionController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 08/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SubjectSummaryMyOpinionController: UIViewController, IndicatorInfoProvider, SubjectOpinionNetwork {
    
    var subject : SubjectItem?
    var opinion : OpinionItem?
    @IBOutlet weak var myOpinionCard: OpinionCardView!
    @IBOutlet weak var myOpinionCardHeight: NSLayoutConstraint!
    @IBOutlet weak var noOpinionText: UILabel!
    @IBOutlet weak var loading: LoadingView!
    @IBOutlet weak var reviewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        loading.isHidden = false
        myOpinionCard.isHidden = true
        noOpinionText.isHidden = true
        myOpinionCard.layer.cornerRadius = 15.0
        self.getOpinions(subjectID: subject!.id!, userUID: currentUser?.uid)
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TU OPINIÓN")
    }
    
    func loadSubject(subj: SubjectItem) {
        self.subject = subj
    }
    
    func arrivedOpinions(opinions: [OpinionItem]) {
        loading.isHidden = true
        if opinions.count > 0 {
            myOpinionCard.isHidden = false
            myOpinionCard.commonInit(op: opinions.first!)
            myOpinionCardHeight.constant = 80 + myOpinionCard.content.contentSize.height
            reviewButton.setTitle("CAMBIAR OPINIÓN", for: .normal)
            opinion = opinions.first
        } else {
            noOpinionText.isHidden = false
            reviewButton.setTitle("OPINAR", for: .normal)
        }
    }
    
    @IBAction func goToReview(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReviewSubject") as! ReviewSubjectController
        controller.loadSubject(subj: subject!)
        if opinion != nil {
            controller.loadOpinion(op: opinion!)
        }
        self.present(controller, animated: false, completion: nil)
    }
}
