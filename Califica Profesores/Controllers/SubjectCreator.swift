//
//  SubjectCreator.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 22/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit

class SubjectCreator: UIViewController, AddSubject {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var professorSelectorHeight: NSLayoutConstraint!
    @IBOutlet weak var schoolSelectorHeight: NSLayoutConstraint!
    @IBOutlet weak var subjectName: UITextField!
    
    var schoolSelector : SchoolSelectorViewController?
    var professorSelector : ProfessorSelectorViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar(title: "Agregar Materia")
        // ARREGLO EL BUG DEL TECLADO
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // AGREGO PARA QUE SE CIERRE EL TECLADO TOCANDO AFUERA
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReviewSubjectController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // OBTENGO LOS HIJOS
        schoolSelector = self.children[0] as? SchoolSelectorViewController
        professorSelector = self.children[1] as? ProfessorSelectorViewController
    }
    
    @objc func dismissKeyboard(sender:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let new_inset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect!.height, right: 0)
        scrollView.contentInset = new_inset
        scrollView.scrollIndicatorInsets = new_inset
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let new_inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = new_inset
        scrollView.scrollIndicatorInsets = new_inset
    }

    @IBAction func send(_ sender: UIButton) {
        let schoolCard = schoolSelector?.selectedList?.cards.first as? SelectorCard
        let subject = SubjectItem()
        subject.count = 0
        subject.Facultad = schoolCard?.id
        subject.FacultadName = schoolCard?.tit
        subject.Name = subjectName.text?.lowercased()
            .replacingOccurrences(of: "á", with: "a")
            .replacingOccurrences(of: "é", with: "e")
            .replacingOccurrences(of: "í", with: "i")
            .replacingOccurrences(of: "ó", with: "o")
            .replacingOccurrences(of: "ú", with: "u")
        subject.prof = [:]
        subject.ShownName = subjectName.text
        subject.totalScore = 0
        if professorSelector!.addLaterSwitch.isOn == false {
            for card in professorSelector!.selectedList!.cards as! [SelectorCard] {
                subject.prof[card.id!] = card.tit
            }
        }
        self.add(subj: subject)
    }
    
    func finishedSend(success: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
}

class SchoolSelectorViewController: UIViewController, SchoolNetwork, SelectorCardDelegate {
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var selectedListHeight: NSLayoutConstraint!
    @IBOutlet weak var inputContainerHeight: NSLayoutConstraint!
    var searchList : SelectorViewListController?
    var selectedList : SelectorViewListController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 15.0
        searchBar.placeholder = "Facultad..."
        searchBar.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        selectedListHeight.constant = 0
        selectedList = self.children[1] as? SelectorViewListController
        searchList = self.children[0] as? SelectorViewListController
        selectedList?.collectionView.isScrollEnabled = false
        searchList?.collectionView.isScrollEnabled = false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.searchSchools(keyword: textField.text!)
        searchList?.update(cards: [LoadingCard()])
    }
    
    func arrivedSchools(schools: [SchoolItem]) {
        var profCards : [SelectorCard] = []
        for school in schools {
            if !selected(id: school.id!) {
                profCards.append(
                    SelectorCard(
                        title: school.Name!.uppercased(),
                        description: school.ShownName!,
                        id: school.id!,
                        delegate: self
                    )
                )
            }
        }
        searchList!.update(cards: profCards)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.updateHeight()
        })
    }
    
    func updateHeight() {
        selectedListHeight.constant = selectedList!.collectionView.contentSize.height + 4
        let parentObj = parent as! SubjectCreator
        var height = selectedListHeight.constant
        height += (inputContainerHeight.isActive) ? 0 : 52
        height += searchList!.collectionView.contentSize.height
        height += 4
        
        parentObj.schoolSelectorHeight.constant = height
    }
    
    func selected(id: String) -> Bool {
        for card in selectedList!.cards as! [SelectorCard] {
            if card.id == id { return true }
        }
        return false
    }
    
    func selectedCard(card: SelectorCard) {
        if card.parent! == searchList {
            searchList!.update(cards: [])
            self.searchBar.text = ""
            var currentSelected = selectedList!.cards as! [SelectorCard]
            currentSelected.append(SelectorCard(title: card.mainView!.title.text!, description: card.mainView!.desc.text!, id: card.id!, delegate: self))
            selectedList!.update(cards: currentSelected)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.updateHeight()
            })
        } else {
            var currentSelected = selectedList!.cards as! [SelectorCard]
            currentSelected.removeAll { (current) -> Bool in
                return current.id! == card.id!
            }
            selectedList!.update(cards: currentSelected)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.updateHeight()
            })
        }
        if selectedList?.cards.count == 1 {
            inputContainerHeight.isActive = true
            searchBar?.isHidden = true
        } else {
            inputContainerHeight.isActive = false
            searchBar?.isHidden = false
        }
    }
    
}

class ProfessorSelectorViewController: UIViewController, ProfessorListNetwork, SelectorCardDelegate {
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var selectedListHeight: NSLayoutConstraint!
    @IBOutlet weak var addLaterSwitch: UISwitch!
    @IBOutlet weak var inputContainerHeight: NSLayoutConstraint!
    var searchList : SelectorViewListController?
    var selectedList : SelectorViewListController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 15.0
        searchBar.placeholder = "Profesores..."
        searchBar.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        selectedListHeight.constant = 0
        selectedList = self.children[1] as? SelectorViewListController
        searchList = self.children[0] as? SelectorViewListController
        selectedList?.collectionView.isScrollEnabled = false
        searchList?.collectionView.isScrollEnabled = false
        addLaterSwitch.addTarget(self, action: #selector(addLaterChanged(_:)), for: .valueChanged)
        addLaterChanged(addLaterSwitch)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.searchProfessors(keyword: textField.text!)
        searchList?.update(cards: [LoadingCard()])
    }
    
    @objc func addLaterChanged(_ addLater: UISwitch) {
        if addLater.isOn {
            inputContainerHeight.isActive = true
            searchBar.isHidden = true
            selectedListHeight.constant = 0
            let parentObj = parent as? SubjectCreator
            parentObj?.professorSelectorHeight.constant = 50
        } else {
            inputContainerHeight.isActive = false
            searchBar.isHidden = false
            updateHeight()
        }
    }
    
    func arrivedProfessors(professors: [ProfessorItem]) {
        var profCards : [SelectorCard] = []
        for prof in professors {
            if !selected(id: prof.id!) {
                profCards.append(
                    SelectorCard(
                        title: prof.Name!,
                        description: (prof.Facultades.count > 0) ? prof.Facultades.values.joined(separator: ", ") : "Sin facultades",
                        id: prof.id!,
                        delegate: self
                    )
                )
            }
        }
        searchList!.update(cards: profCards)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.updateHeight()
        })

    }
    
    func updateHeight() {
        selectedListHeight.constant = selectedList!.collectionView.contentSize.height + 4
        let parentObj = parent as! SubjectCreator
        parentObj.professorSelectorHeight.constant = selectedListHeight.constant + 52 + searchList!.collectionView.contentSize.height + 4 + 50
    }
    
    func selected(id: String) -> Bool {
        for card in selectedList!.cards as! [SelectorCard] {
            if card.id == id { return true }
        }
        return false
    }
    
    func selectedCard(card: SelectorCard) {
        if card.parent! == searchList {
            searchList!.update(cards: [])
            self.searchBar.text = ""
            var currentSelected = selectedList!.cards as! [SelectorCard]
            currentSelected.append(SelectorCard(title: card.mainView!.title.text!, description: card.mainView!.desc.text!, id: card.id!, delegate: self))
            selectedList!.update(cards: currentSelected)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.updateHeight()
            })
        } else {
            var currentSelected = selectedList!.cards as! [SelectorCard]
            currentSelected.removeAll { (current) -> Bool in
                return current.id! == card.id!
            }
            selectedList!.update(cards: currentSelected)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.updateHeight()
            })
        }
    }
    
}
