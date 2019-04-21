//
//  AddSubjectsToProfessor.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 25/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit

class AddSubjectsToProfessor: UIViewController, AddProfessor {
    
    @IBOutlet weak var professorName: UILabel!
    @IBOutlet weak var subjectSelectorHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sendButton: UIButton!
    
    var subjectSelector : SubjectSelectorViewController?
    var professor : ProfessorItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar(title: "Agregar Materias")
        // ARREGLO EL BUG DEL TECLADO
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // AGREGO PARA QUE SE CIERRE EL TECLADO TOCANDO AFUERA
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        // OBTENGO LOS HIJOS
        subjectSelector = children.first as? SubjectSelectorViewController
        subjectSelector?.addLaterSwitch.isOn = false
        subjectSelector?.addLaterChanged(subjectSelector!.addLaterSwitch)
        subjectSelector?.addLaterSwitch.isEnabled = false
        professorName.text = professor?.Name
        updateButtonStatus()
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
    
    func updateButtonStatus() {
        var enabled = true
        if subjectSelector != nil && subjectSelector?.selectedList != nil && subjectSelector!.selectedList!.cards.count == 0 {
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
    
    func loadProfessor(prof: ProfessorItem?) {
        self.professor = prof
    }

    @IBAction func send(_ sender: UIButton) {
        var request = ProfessorAddRequest()
        request.create = false
        request.erase = false
        request.profId = professor?.id
        request.profName = professor?.Name
        request.timestamp = Int(Date().timeIntervalSince1970 * 1000.0)
        request.facultades = professor!.Facultades
        for subj in professor!.Mat {
            request.materias[subj.id!] = [
                "facultad": subj.FacultadName!,
                "nombre": subj.ShownName!
            ]
        }
        if subjectSelector?.addLaterSwitch.isOn == false {
            for card in subjectSelector?.selectedList?.cards as! [SelectorCard] {
                let subject = subjectSelector?.subjects.first(where: { $0.id! == card.id! })
                request.materias[card.id!] = [
                    "facultad": subject!.FacultadName!,
                    "nombre": subject!.ShownName!
                ]
                request.facultades[subject!.Facultad!] = subject!.FacultadName!
                professor?.Mat.append(subject!)
            }
        }
        add(subj: request)
    }

    func finishedSend(success: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
}
