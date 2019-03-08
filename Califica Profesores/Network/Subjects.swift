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

extension SubjectsNetwork {
    func searchSubjects(keyword : String) {
        let keywordModified = keyword.lowercased()
            .replacingOccurrences(of: "á", with: "a")
            .replacingOccurrences(of: "é", with: "e")
            .replacingOccurrences(of: "í", with: "i")
            .replacingOccurrences(of: "ó", with: "o")
            .replacingOccurrences(of: "ú", with: "u")
        let ref = Database.database().reference()
        ref
        .child("Materias")
        .queryOrdered(byChild: "Name")
        .queryStarting(atValue: keywordModified)
        .queryEnding(atValue: keywordModified + "\u{f8ff}")
        .observeSingleEvent(of: .value, with: { (snapshot) in
            var children : [SubjectItem] = []
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                if childSnapshot.key == "0" {
                    continue
                }
                let childDict = childSnapshot.value as! NSDictionary
                let current = SubjectItem()
                current.id = childSnapshot.key
                current.Facultad = childDict["Facultad"] as? String
                current.FacultadName = childDict["FacultadName"] as? String
                current.Name = childDict["Name"] as? String
                current.ShownName = childDict["ShownName"] as? String
                current.count = childDict["count"] as? Int
                current.totalScore = childDict["totalScore"] as? Int
                current.prof = []
                for prof in childSnapshot.childSnapshot(forPath: "Prof").children {
                    let profSnapshot = prof as! DataSnapshot
                    current.prof!.append(profSnapshot.key)
                }
                children.append(current)
            }
            self.arrivedSubjects(subjects: children)
        })
    }
}
