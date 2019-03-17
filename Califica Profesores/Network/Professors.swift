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
    var id : String?
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
                professor.id = snapshot.key
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

protocol ProfessorListNetwork {
    func arrivedProfessors(professors: [ProfessorItem])
}

extension ProfessorListNetwork {
    func searchProfessors(keyword : String) {
        let keywordModified = keyword.lowercased()
            .replacingOccurrences(of: "á", with: "a")
            .replacingOccurrences(of: "é", with: "e")
            .replacingOccurrences(of: "í", with: "i")
            .replacingOccurrences(of: "ó", with: "o")
            .replacingOccurrences(of: "ú", with: "u")
        let ref = Database.database().reference()
        ref
            .child("Prof")
            .queryOrdered(byChild: "SearchName")
            .queryStarting(atValue: keywordModified)
            .queryEnding(atValue: keywordModified + "\u{f8ff}")
            .observeSingleEvent(of: .value, with: { (snapshot) in
                var children : [ProfessorItem] = []
                for child in snapshot.children {
                    let childSnapshot = child as! DataSnapshot
                    if childSnapshot.key == "0" {
                        continue
                    }
                    let childDict = childSnapshot.value as! NSDictionary
                    let professor = ProfessorItem()
                    professor.id = childSnapshot.key
                    professor.Name = childDict["Name"] as? String
                    professor.SearchName = childDict["SearchName"] as? String
                    professor.amabilidad = childDict["amabilidad"] as? Int
                    professor.clases = childDict["clases"] as? Int
                    professor.conocimiento = childDict["conocimiento"] as? Int
                    professor.count = childDict["count"] as? Int
                    professor.Facultades = []
                    professor.Mat = []
                    for facultades in childSnapshot.childSnapshot(forPath: "Facultades").children {
                        let facSnap = facultades as! DataSnapshot
                        professor.Facultades?.append(facSnap.value as! String)
                    }
                    for materias in childSnapshot.childSnapshot(forPath: "Mat").children {
                        let matSnap = materias as! DataSnapshot
                        professor.Mat?.append(matSnap.key)
                    }
                    children.append(professor)
                }
                self.arrivedProfessors(professors: children)
            })
    }
}
