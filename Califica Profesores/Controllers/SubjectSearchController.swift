//
//  SubjectSearchController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 06/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit

class SubjectSearchController: UIViewController, UISearchControllerDelegate {
    var searchController : UISearchController?
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var subjectSearchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let controller = self.children.first as! SubjectListController
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = controller
        searchController?.obscuresBackgroundDuringPresentation = false
        searchBarContainer.addSubview((searchController?.searchBar)!)
    }

}
