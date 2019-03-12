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
    func getOpinions(subjectID : String, userUID: String? = nil) {
        var ref = Database.database().reference()
            .child("OpinionesMaterias")
            .child(subjectID)
        if (userUID != nil) {
            ref = ref.child(userUID!)
        }
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var opinions : [OpinionItem] = []
            if (userUID != nil) {
                if snapshot.childrenCount != 0 {
                    opinions.append(self.snapToOpinion(opSnap: snapshot))
                }
            } else {
                for op in snapshot.children {
                    opinions.append(self.snapToOpinion(opSnap: op as! DataSnapshot))
                }
            }
            self.arrivedOpinions(opinions: opinions)
        })
    }
    
    private func snapToOpinion(opSnap : DataSnapshot) -> OpinionItem {
        let opDict = opSnap.value as! NSDictionary
        let opinion = OpinionItem()
        opinion.anonimo = opDict["anonimo"] as? Bool
        opinion.author = opDict["author"] as? String
        opinion.conTexto = opDict["conTexto"] as? Bool
        opinion.content = opDict["content"] as? String
        opinion.likes = opDict["likes"] as? Int
        opinion.timestamp = opDict["timestamp"] as? Int
        opinion.valoracion = opDict["valoracion"] as? Int
        return opinion
    }
}
