//
//  SubjectSummaryGeneral.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 07/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import Cosmos
import XLPagerTabStrip

class SubjectSummaryGeneralController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "VISTA GENERAL")
    }
    
    
    @IBOutlet weak var generalRank: CosmosView!
    @IBOutlet weak var noOpinionView: NotFoundView!
    var subject : SubjectItem?
    @IBOutlet weak var noOpinionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rankHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (subject == nil) { return }
        if (subject!.count! != 0) {
            generalRank.isHidden = false
            generalRank.rating = Double(subject!.totalScore!) / Double(2*subject!.count!)
        } else {
            noOpinionView.isHidden = false
            let rankController =  storyboard?.instantiateViewController(withIdentifier: "ReviewSubject") as! ReviewSubjectController
            rankController.loadSubject(subj: subject!)
            noOpinionView.configure(description: "No hay opiniones", buttonText: "¡SÉ EL PRIMERO!", redirectController: rankController)
            noOpinionViewHeight.isActive = true
            rankHeight.isActive = false
        }
        var profIDs : [String] = []
        for profid in subject!.prof.keys {
            profIDs.append(profid)
        }
        let professors = self.children.first as! SubjectProfessorListController
        professors.loadProfessors(professors: profIDs)
    }
    
    func loadSubject(subject: SubjectItem) {
        self.subject = subject
    }

}
