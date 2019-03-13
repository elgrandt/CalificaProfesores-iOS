//
//  ReviewSubjectController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 10/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import BEMCheckBox
import Cosmos

class ReviewSubjectController: UIViewController, UITextViewDelegate, ReviewSubjectNetwork {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var anonymousCheckbox: BEMCheckBox!
    @IBOutlet weak var anonymousLabel: UILabel!
    @IBOutlet weak var norateCheckbox: BEMCheckBox!
    @IBOutlet weak var norateLabel: UILabel!
    @IBOutlet weak var rate: CosmosView!
    @IBOutlet weak var sendButton: UIButton!
    var subject : SubjectItem?
    var opinion : OpinionItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "Comentario..."
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(ReviewSubjectController.switchAnonymous))
        anonymousLabel.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ReviewSubjectController.switchNorate))
        norateLabel.addGestureRecognizer(tap2)
        let tap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReviewSubjectController.dismissKeyboard))
        view.addGestureRecognizer(tap3)
        sendButton.isEnabled = false
        sendButton.alpha = 0.6
        if opinion != nil {
            configure()
        }
    }
    
    func configure() {
        self.rate.rating = Double(opinion!.valoracion!) / 2.0
        textViewDidBeginEditing(textView)
        textView.text = opinion!.content!
        norateCheckbox.setOn(!(opinion!.conTexto!), animated: false)
        anonymousCheckbox.setOn(opinion!.anonimo!, animated: false)
        noRankChanged(norateCheckbox)
        textViewDidChange(textView)
        textViewDidEndEditing(textView)
    }
    
    @objc func dismissKeyboard(sender:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func switchAnonymous(sender:UITapGestureRecognizer) {
        anonymousCheckbox.setOn(!anonymousCheckbox.on, animated: true)
    }
    
    @objc func switchNorate(sender:UITapGestureRecognizer) {
        norateCheckbox.setOn(!norateCheckbox.on, animated: true)
        noRankChanged(norateCheckbox)
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        let opinion = OpinionItem()
        opinion.anonimo = anonymousCheckbox.on
        if (opinion.anonimo!) {
            opinion.author = "Anónimo"
        } else {
            opinion.author = currentUser?.displayName
        }
        if (textView.textColor == UIColor.lightGray) {
            opinion.content = ""
        } else {
            opinion.content = textView.text
        }
        opinion.conTexto = !(norateCheckbox.on)
        opinion.likes = 0
        opinion.timestamp = Int(Date().timeIntervalSince1970 * 1000.0)
        opinion.valoracion = Int(rate.rating * 2)
        sendReview(opinion: opinion, subjectId: subject!.id!, userUID: currentUser!.uid)
    }
    
    func finishedSend(success: Bool) {
        if (success) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func loadSubject(subj : SubjectItem) {
        self.subject = subj
    }
    
    func loadOpinion(op: OpinionItem) {
        opinion = op
    }
    
    @IBAction func noRankChanged(_ sender: BEMCheckBox) {
        if sender.on {
            sendButton.isEnabled = true
            sendButton.alpha = 1
        } else if textView.text != nil && textView.text != "" {
            sendButton.isEnabled = false
            sendButton.alpha = 0.6
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text != nil && textView.text != "") || norateCheckbox.on {
            sendButton.isEnabled = true
            sendButton.alpha = 1
        } else {
            sendButton.isEnabled = false
            sendButton.alpha = 0.6
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comentario..."
            textView.textColor = UIColor.lightGray
        }
    }
}
