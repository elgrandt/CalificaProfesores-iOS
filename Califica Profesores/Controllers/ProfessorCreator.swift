//
//  ProfessorCreator.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 25/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit

class ProfessorCreator: UIViewController, AddProfessor {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var subjectSelectorHeight: NSLayoutConstraint!
    @IBOutlet weak var professorName: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var subjectSelector : SubjectSelectorViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar(title: "Agregar Profesor")
        // ARREGLO EL BUG DEL TECLADO
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // AGREGO PARA QUE SE CIERRE EL TECLADO TOCANDO AFUERA
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReviewSubjectController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // OBTENGO LOS HIJOS
        subjectSelector = children.first as? SubjectSelectorViewController
        self.updateButtonStatus()
        professorName.addTarget(self, action: #selector(nameInputChanged(_:)), for: .editingChanged)
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
    
    @objc func nameInputChanged(_ sender: UITextField) {
        self.updateButtonStatus()
    }
    
    func updateButtonStatus() {
        var enabled = true
        if professorName.text == nil || professorName.text == "" {
            enabled = false
        }
        if enabled {
            sendButton.isEnabled = true
            sendButton.alpha = 1
        } else {
            sendButton.isEnabled = false
            sendButton.alpha = 0.6
        }
    }
    
    @IBAction func send(_ sender: UIButton) {
        var request = ProfessorAddRequest()
        request.create = true
        request.erase = false
        request.profName = professorName.text
        request.timestamp = Int(Date().timeIntervalSince1970 * 1000.0)
        if subjectSelector?.addLaterSwitch.isOn == false {
            for card in subjectSelector?.selectedList?.cards as! [SelectorCard] {
                let subject = subjectSelector?.subjects.first(where: { $0.id! == card.id! })
                request.materias[card.id!] = [
                    "facultad": subject!.FacultadName!,
                    "nombre": subject!.ShownName!
                ]
                request.facultades[subject!.Facultad!] = subject!.FacultadName!
            }
            
        }
        add(subj: request)
    }
    
    func finishedSend(success: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
}

class SubjectSelectorViewController: UIViewController, SubjectsNetwork, SelectorCardDelegate {
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var selectedListHeight: NSLayoutConstraint!
    @IBOutlet weak var addLaterSwitch: UISwitch!
    @IBOutlet weak var inputContainerHeight: NSLayoutConstraint!
    var searchList : SelectorViewListController?
    var selectedList : SelectorViewListController?
    var subjects : [SubjectItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 15.0
        searchBar.placeholder = "Materias..."
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
        self.searchSubjects(keyword: textField.text!)
        searchList?.update(cards: [LoadingCard()])
    }
    
    @objc func addLaterChanged(_ addLater: UISwitch) {
        if addLater.isOn {
            inputContainerHeight.isActive = true
            searchBar.isHidden = true
            selectedListHeight.constant = 0
            var constrait: NSLayoutConstraint?
            if parent is ProfessorCreator {
                let parentObj = parent as? ProfessorCreator
                constrait = parentObj?.subjectSelectorHeight
            } else {
                let parentObj = parent as? AddSubjectsToProfessor
                constrait = parentObj?.subjectSelectorHeight
            }
            constrait?.constant = 50
        } else {
            inputContainerHeight.isActive = false
            searchBar.isHidden = false
            updateHeight()
        }
    }
    
    func arrivedSubjects(subjects: [SubjectItem]) {
        self.subjects.append(contentsOf: subjects)
        var profCards : [SelectorCard] = []
        for subj in subjects {
            if !selected(id: subj.id!) {
                profCards.append(
                    SelectorCard(
                        title: subj.ShownName!,
                        description: subj.FacultadName!,
                        id: subj.id!,
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
        var constrait : NSLayoutConstraint?
        if parent is ProfessorCreator {
            let parentObj = parent as? ProfessorCreator
            constrait = parentObj?.subjectSelectorHeight
        } else {
            let parentObj = parent as? AddSubjectsToProfessor
            constrait = parentObj?.subjectSelectorHeight
        }
        constrait?.constant = selectedListHeight.constant + 52 + searchList!.collectionView.contentSize.height + 4 + 50
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
        if let parent = self.parent as? AddSubjectsToProfessor {
            parent.updateButtonStatus()
        }
    }
    
}
