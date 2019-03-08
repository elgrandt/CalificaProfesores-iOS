//
//  Professors.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 08/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import Firebase

class ProfessorItem {
    var Name : String?
    var SearchName : String?
    var amabilidad : Int?
    var clases : Int?
    var conocimiento : Int?
    var count : Int?
    var Facultades : [String]?
    var Mat : [String]?
}

protocol ProfessorsNetwork {
    func arrivedProfessor(professor : ProfessorItem)
}

extension ProfessorsNetwork {
    func searchProfessor(hash : String) {
        let ref = Database.database().reference()
        ref
            .child("Prof")
            .child(hash)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                let dataDict = snapshot.value as! NSDictionary
                let professor = ProfessorItem()
                professor.Name = dataDict["Name"] as? String
                professor.SearchName = dataDict["SearchName"] as? String
                professor.amabilidad = dataDict["amabilidad"] as? Int
                professor.clases = dataDict["clases"] as? Int
                professor.conocimiento = dataDict["conocimiento"] as? Int
                professor.count = dataDict["count"] as? Int
                professor.Facultades = []
                professor.Mat = []
                for facultades in snapshot.childSnapshot(forPath: "Facultades").children {
                    let facSnap = facultades as! DataSnapshot
                    professor.Facultades?.append(facSnap.value as! String)
                }
                for materias in snapshot.childSnapshot(forPath: "Mat").children {
                    let matSnap = materias as! DataSnapshot
                    professor.Mat?.append(matSnap.key)
                }
                self.arrivedProfessor(professor: professor)
            })
    }
}
