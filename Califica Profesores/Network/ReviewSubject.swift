//
//  ReviewSubject.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 11/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import Firebase

protocol ReviewSubjectNetwork {
    func finishedSend(success : Bool)
}

extension ReviewSubjectNetwork {
    func sendReview(opinion: OpinionItem, subjectId: String, userUID: String) {
        let ref = Database.database().reference()
        let dict : [String : Any] = [
            "anonimo" : opinion.anonimo! as Any,
            "author" : opinion.author! as Any,
            "conTexto" : opinion.conTexto! as Any,
            "content" : opinion.content! as Any,
            "likes" : opinion.likes! as Any,
            "timestamp" : opinion.timestamp! as Any,
            "valoracion" : opinion.valoracion! as Any
        ]
        ref
        .child("OpinionesMaterias")
        .child(subjectId)
        .child(userUID)
        .setValue(dict) { (error, database) in
            var suc = false
            if (error == nil) {
                suc = true
            }
            self.finishedSend(success: suc)
        }
    }
}
