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
    var Mat : [SubjectItem] = []
    var id : String?
}

protocol ProfessorsNetwork {
    func arrivedProfessor(professor : ProfessorItem)
}

func SnapToProfessor(snap: DataSnapshot) -> ProfessorItem {
    let dataDict = snap.value as! NSDictionary
    let professor = ProfessorItem()
    professor.id = snap.key
    professor.Name = dataDict["Name"] as? String
    professor.SearchName = dataDict["SearchName"] as? String
    professor.amabilidad = dataDict["amabilidad"] as? Int
    professor.clases = dataDict["clases"] as? Int
    professor.conocimiento = dataDict["conocimiento"] as? Int
    professor.count = dataDict["count"] as? Int
    professor.Facultades = []
    for facultades in snap.childSnapshot(forPath: "Facultades").children {
        let facSnap = facultades as! DataSnapshot
        professor.Facultades?.append(facSnap.value as! String)
    }
    for materias in snap.childSnapshot(forPath: "Mat").children {
        let matSnap = materias as! DataSnapshot
        let current = SubjectItem()
        current.FacultadName = matSnap.childSnapshot(forPath: "facultad").value as? String
        current.ShownName = matSnap.childSnapshot(forPath: "nombre").value as? String
        current.id = matSnap.key
        professor.Mat.append(current)
    }
    return professor
}

extension ProfessorsNetwork {
    func searchProfessor(hash : String) {
        let ref = Database.database().reference()
        ref
            .child("Prof")
            .child(hash)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                self.arrivedProfessor(professor: SnapToProfessor(snap: snapshot))
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
                    children.append(SnapToProfessor(snap: childSnapshot))
                }
                self.arrivedProfessors(professors: children)
            })
    }
}

struct ProfessorAddRequest {
    var create : Bool?
    var erase : Bool?
    var facultades : [String:String] = [:]
    var materias : [String:[String:String]] = [:]
    var profId : String?
    var profName : String?
    var timestamp : Int?
}

protocol AddProfessor {
    func finishedSend(success: Bool)
}

extension AddProfessor {
    func add(subj: ProfessorAddRequest) {
        let ref = Database.database().reference()
        let profId = ref
            .child("Prof")
            .childByAutoId()
            .key
        let dict : [String : Any] = [
            "create" : subj.create as Any,
            "erase" : subj.erase as Any,
            "facultades" : subj.facultades as Any,
            "materias" : subj.materias as Any,
            "profId" : profId as Any,
            "profName" : subj.profName as Any,
            "timestamp" : subj.timestamp as Any
        ]
        ref
            .child("ProfAddRequests")
            .child(currentUser!.uid)
            .childByAutoId()
            .setValue(dict) { (error, database) in
                var suc = false
                if (error == nil) {
                    suc = true
                }
                self.finishedSend(success: suc)
        }
    }
}
