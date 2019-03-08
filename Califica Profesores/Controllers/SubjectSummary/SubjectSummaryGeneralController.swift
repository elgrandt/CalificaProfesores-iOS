//
//  SubjectSummaryGeneral.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 07/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import Cosmos

class SubjectSummaryGeneralController: UIViewController {
    
    @IBOutlet weak var generalRank: CosmosView!
    var subject : SubjectItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (subject != nil && subject!.count! != 0) {
            generalRank.rating = Double(subject!.totalScore!) / Double(2*subject!.count!)
        }
        let professors = self.children.first as! ProfessorListController
        professors.loadProfessors(professors: subject?.prof ?? [])
    }

}
