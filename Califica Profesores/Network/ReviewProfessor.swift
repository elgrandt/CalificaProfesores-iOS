//
//  ReviewProfessor.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 21/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import Firebase

protocol ReviewProfessorNetwork {
    func finishedSend(success : Bool)
}

extension ReviewProfessorNetwork {
    func sendReview(opinion: OpinionItem, professorId: String, userUID: String) {
        let ref = Database.database().reference()
        let dict : [String : Any] = [
            "anonimo" : opinion.anonimo! as Any,
            "author" : opinion.author! as Any,
            "conTexto" : opinion.conTexto! as Any,
            "content" : opinion.content! as Any,
            "likes" : opinion.likes! as Any,
            "timestamp" : opinion.timestamp! as Any,
            "amabilidad" : opinion.amabilidad! as Any,
            "clases" : opinion.clases! as Any,
            "conocimiento" : opinion.conocimiento! as Any,
            "materias" : opinion.materias as Any
        ]
        ref
            .child("OpinionesProf")
            .child(professorId)
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
