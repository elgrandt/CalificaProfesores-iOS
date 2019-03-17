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
    var amabilidad : Int?
    var conocimiento : Int?
    var clases : Int?
    var materias : [String:String] = [:]
}

protocol SubjectOpinionNetwork {
    func arrivedOpinions(opinions : [OpinionItem])
}

func snapToOpinion(opSnap : DataSnapshot) -> OpinionItem {
    let opDict = opSnap.value as! NSDictionary
    let opinion = OpinionItem()
    opinion.anonimo = opDict["anonimo"] as? Bool
    opinion.author = opDict["author"] as? String
    opinion.conTexto = opDict["conTexto"] as? Bool
    opinion.content = opDict["content"] as? String
    opinion.likes = opDict["likes"] as? Int
    opinion.timestamp = opDict["timestamp"] as? Int
    opinion.valoracion = opDict["valoracion"] as? Int
    opinion.amabilidad = opDict["amabilidad"] as? Int
    opinion.conocimiento = opDict["conocimiento"] as? Int
    opinion.clases = opDict["clases"] as? Int
    if opSnap.hasChild("materias") {
        opinion.materias = opSnap.childSnapshot(forPath: "materias").value as! [String:String]
    }
    return opinion
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
                    opinions.append(snapToOpinion(opSnap: snapshot))
                }
            } else {
                for op in snapshot.children {
                    opinions.append(snapToOpinion(opSnap: op as! DataSnapshot))
                }
            }
            self.arrivedOpinions(opinions: opinions)
        })
    }
}

protocol ProfessorOpinionNetwork {
    func arrivedOpinions(opinions : [OpinionItem])
}

extension ProfessorOpinionNetwork {
    func getOpinions(profID : String, userUID: String? = nil) {
        var ref = Database.database().reference()
            .child("OpinionesProf")
            .child(profID)
        if (userUID != nil) {
            ref = ref.child(userUID!)
        }
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var opinions : [OpinionItem] = []
            if (userUID != nil) {
                if snapshot.childrenCount != 0 {
                    opinions.append(snapToOpinion(opSnap: snapshot))
                }
            } else {
                for op in snapshot.children {
                    opinions.append(snapToOpinion(opSnap: op as! DataSnapshot))
                }
            }
            self.arrivedOpinions(opinions: opinions)
        })
    }
}
