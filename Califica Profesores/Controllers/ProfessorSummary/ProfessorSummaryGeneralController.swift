//
//  ProfessorSummaryGeneralController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 13/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Cosmos

class ProfessorSummaryGeneralController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "VISTA GENERAL")
    }
    
    var professor: ProfessorItem?
    @IBOutlet weak var generalRank: CosmosView!
    @IBOutlet weak var noOpinionView: NotFoundView!
    @IBOutlet weak var noOpinionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rankHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (professor == nil) { return }
        let info = children.first as! ProfessorSummaryInfoController
        info.loadProfessor(prof: professor!)
        if (professor != nil && professor!.count != nil && professor!.count! != 0) {
            generalRank.isHidden = false
            generalRank.rating = Double(professor!.amabilidad! + professor!.clases! + professor!.conocimiento!) / Double(3*professor!.count!)
        } else {
            noOpinionView.isHidden = false
            let rankController = self.storyboard?.instantiateViewController(withIdentifier: "ReviewProfessor") as! ReviewProfessorController
            rankController.loadProfessor(prof: professor!)
            noOpinionView.configure(description: "No hay opiniones", buttonText: "¡SÉ EL PRIMERO!", redirectController: rankController)
            noOpinionViewHeight.isActive = true
            rankHeight.isActive = false
        }
    }
    
    func loadProfessor(professor: ProfessorItem) {
        self.professor = professor
    }
}
