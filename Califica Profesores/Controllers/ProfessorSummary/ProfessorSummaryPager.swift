
//
//  ProfessorSummaryController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 13/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ProfessorSummaryPager: ButtonBarPagerTabStripViewController {
    
    var professor : ProfessorItem?
    @IBOutlet weak var bar: ButtonBarView!
    
    override func viewDidLoad() {
        let light_gray = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1)
        self.settings.style.buttonBarBackgroundColor = light_gray
        self.settings.style.buttonBarItemBackgroundColor = light_gray
        self.settings.style.buttonBarItemFont = UIFont(name: "Arial-BoldMT", size: 12.0)!
        self.settings.style.buttonBarItemTitleColor = UIColor(red: 120.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1)
        self.settings.style.buttonBarRightContentInset = 0
        self.settings.style.buttonBarRightContentInset = 0
        self.settings.style.selectedBarHeight = 3
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
        super.viewDidLoad()
        self.setupNavigationBar(title: "Resúmen")
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let general = self.storyboard?.instantiateViewController(withIdentifier: "ProfessorGeneral") as! ProfessorSummaryGeneralController
        let opinions = self.storyboard?.instantiateViewController(withIdentifier: "ProfessorOpinions") as! ProfessorSummaryOpinionsController
        let my_opinion = self.storyboard?.instantiateViewController(withIdentifier: "ProfessorMyOpinion") as! ProfessorSummaryMyOpinionController
        if professor != nil {
            general.loadProfessor(professor: professor!)
            opinions.loadProfessor(professor: professor!)
            my_opinion.loadProfessor(professor: professor!)
        }
        return [general, opinions, my_opinion]
    }
    
    func loadProfessor(professor: ProfessorItem) {
        self.professor = professor
    }
    
}
