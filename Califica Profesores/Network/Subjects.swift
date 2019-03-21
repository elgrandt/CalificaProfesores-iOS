//
//  Subjects.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 06/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import Firebase

class SubjectItem {
    var Facultad : String?
    var FacultadName : String?
    var Name: String?
    var ShownName : String?
    var count : Int?
    var totalScore : Int?
    var prof : [String]?
    var id : String?
}

protocol SubjectsNetwork {
    func arrivedSubjects(subjects : [SubjectItem])
}

func SnapToSubject(snap: DataSnapshot) -> SubjectItem {
    let dict = snap.value as! NSDictionary
    let current = SubjectItem()
    current.id = snap.key
    current.Facultad = dict["Facultad"] as? String
    current.FacultadName = dict["FacultadName"] as? String
    current.Name = dict["Name"] as? String
    current.ShownName = dict["ShownName"] as? String
    current.count = dict["count"] as? Int
    current.totalScore = dict["totalScore"] as? Int
    current.prof = []
    for prof in snap.childSnapshot(forPath: "Prof").children {
        let profSnapshot = prof as! DataSnapshot
        current.prof!.append(profSnapshot.key)
    }
    return current
}

extension SubjectsNetwork {
    func searchSubjects(keyword : String? = nil, hash : String? = nil) {
        var query : DatabaseQuery?
        if keyword != nil {
            let keywordModified = keyword!.lowercased()
                .replacingOccurrences(of: "á", with: "a")
                .replacingOccurrences(of: "é", with: "e")
                .replacingOccurrences(of: "í", with: "i")
                .replacingOccurrences(of: "ó", with: "o")
                .replacingOccurrences(of: "ú", with: "u")
            query = Database.database().reference()
                .child("Materias")
                .queryOrdered(byChild: "Name")
                .queryStarting(atValue: keywordModified)
                .queryEnding(atValue: keywordModified + "\u{f8ff}")
        } else {
            query = Database.database().reference()
                .child("Materias")
                .child(hash!)
        }
        
        query!.observeSingleEvent(of: .value, with: { (snapshot) in
            if keyword != nil {
                var children : [SubjectItem] = []
                for child in snapshot.children {
                    let childSnapshot = child as! DataSnapshot
                    if childSnapshot.key == "0" {
                        continue
                    }
                    children.append(SnapToSubject(snap: childSnapshot))
                }
                self.arrivedSubjects(subjects: children)
            } else {
                self.arrivedSubjects(subjects: [SnapToSubject(snap: snapshot)])
            }
        })
    }
}
