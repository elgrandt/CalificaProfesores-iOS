//
//  Opinions.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 08/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import Firebase

class OpinionItem {
    var anonimo : Bool?
    var author : String?
    var conTexto : Bool?
    var content : String?
    var likes : Int?
    var timestamp : Int?
    var valoracion : Int?
}

protocol SubjectOpinionNetwork {
    func arrivedOpinions(opinions : [OpinionItem])
}

extension SubjectOpinionNetwork {
    func getOpinions(subjectID : String) {
        let ref = Database.database().reference()
        ref
            .child("OpinionesMaterias")
            .child(subjectID)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                var opinions : [OpinionItem] = []
                for op in snapshot.children {
                    let opSnap = op as! DataSnapshot
                    let opDict = opSnap.value as! NSDictionary
                    let opinion = OpinionItem()
                    opinion.anonimo = opDict["anonimo"] as? Bool
                    opinion.author = opDict["author"] as? String
                    opinion.conTexto = opDict["conTexto"] as? Bool
                    opinion.content = opDict["content"] as? String
                    opinion.likes = opDict["likes"] as? Int
                    opinion.timestamp = opDict["timestamp"] as? Int
                    opinion.valoracion = opDict["valoracion"] as? Int
                    opinions.append(opinion)
                }
                self.arrivedOpinions(opinions: opinions)
            })
    }
}
