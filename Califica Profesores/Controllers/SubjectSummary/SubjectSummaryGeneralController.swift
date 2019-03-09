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
    var subject : SubjectItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (subject == nil) { return }
        if (subject!.count! != 0) {
            generalRank.rating = Double(subject!.totalScore!) / Double(2*subject!.count!)
        }
        let professors = self.children.first as! ProfessorListController
        professors.loadProfessors(professors: subject!.prof ?? [])
    }
    
    func loadSubject(subject: SubjectItem) {
        self.subject = subject
    }

}
