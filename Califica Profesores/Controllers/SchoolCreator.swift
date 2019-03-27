//
//  SchoolCreator.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 26/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit

class SchoolCreator: UIViewController, AddSchool {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullNameInput: UITextField!
    @IBOutlet weak var reducedNameInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ARREGLO EL BUG DEL TECLADO
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // AGREGO PARA QUE SE CIERRE EL TECLADO TOCANDO AFUERA
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReviewSubjectController.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        var request = SchoolAddRequest()
        request.erase = false
        request.timestamp = Int(Date().timeIntervalSince1970 * 1000.0)
        request.uniCompleteName = reducedNameInput.text
        request.uniShortName = fullNameInput.text
        self.add(school: request)
    }
    
    func finishedSend(success: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
}
