//
//  ReviewSubjectController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 10/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import BEMCheckBox

class ReviewSubjectController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var anonymousCheckbox: BEMCheckBox!
    @IBOutlet weak var anonymousLabel: UILabel!
    @IBOutlet weak var norateCheckbox: BEMCheckBox!
    @IBOutlet weak var norateLabel: UILabel!
    
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
    }
    
    @objc func dismissKeyboard(sender:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func switchAnonymous(sender:UITapGestureRecognizer) {
        anonymousCheckbox.setOn(!anonymousCheckbox.on, animated: true)
    }
    
    @objc func switchNorate(sender:UITapGestureRecognizer) {
        norateCheckbox.setOn(!norateCheckbox.on, animated: true)
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        print("HOLA")
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
