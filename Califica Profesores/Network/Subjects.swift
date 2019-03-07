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
}

protocol SubjectsNetwork {
    func arrivedSubjects(subjects : [SubjectItem])
}

extension SubjectsNetwork {
    func searchSubjects(keyword : String) {
        let ref = Database.database().reference()
        ref
        .child("Materias")
        .queryOrdered(byChild: "Name")
        .queryStarting(atValue: keyword.lowercased())
        .queryEnding(atValue: keyword.lowercased() + "\u{f8ff}")
        .observeSingleEvent(of: .value, with: { (snapshot) in
            var children : [SubjectItem] = []
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                if childSnapshot.key == "0" {
                    continue
                }
                let childDict = childSnapshot.value as! NSDictionary
                let current = SubjectItem()
                current.Facultad = childDict["Facultad"] as? String
                current.FacultadName = childDict["FacultadName"] as? String
                current.Name = childDict["Name"] as? String
                current.ShownName = childDict["ShownName"] as? String
                current.count = childDict["count"] as? Int
                current.totalScore = childDict["totalScore"] as? Int
                children.append(current)
            }
            self.arrivedSubjects(subjects: children)
        })
    }
}
