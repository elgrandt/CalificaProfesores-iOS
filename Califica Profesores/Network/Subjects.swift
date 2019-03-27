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
    var prof : [String:String] = [:]
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
    for prof in snap.childSnapshot(forPath: "Prof").children {
        let profSnapshot = prof as! DataSnapshot
        current.prof[profSnapshot.key] = profSnapshot.value as? String
    }
    return current
}

extension SubjectsNetwork {
    func searchSubjects(keyword : String? = nil, hash : String? = nil, school : String? = nil) {
        var query : DatabaseQuery?
        if keyword != nil {
            let keywordModified = keyword!.lowercased()
                .replacingOccurrences(of: "á", with: "a")
                .replacingOccurrences(of: "é", with: "e")
                .replacingOccurrences(of: "í", with: "i")
                .replacingOccurrences(of: "ó", with: "o")
                .replacingOccurrences(of: "ú", with: "u")
            if school == nil {
                query = Database.database().reference()
                    .child("Materias")
                    .queryOrdered(byChild: "Name")
                    .queryStarting(atValue: keywordModified)
                    .queryEnding(atValue: keywordModified + "\u{f8ff}")
            } else {
                query = Database.database().reference()
                    .child("MateriasPorFacultad")
                    .child(school!)
                    .queryOrdered(byChild: "Name")
                    .queryStarting(atValue: keywordModified)
                    .queryEnding(atValue: keywordModified + "\u{f8ff}")
            }
        } else {
            query = Database.database().reference()
                .child("Materias")
                .child(hash!)
        }
        
        query!.observeSingleEvent(of: .value, with: { (snapshot) in
            if keyword != nil && school == nil {
                var children : [SubjectItem] = []
                for child in snapshot.children {
                    let childSnapshot = child as! DataSnapshot
                    if childSnapshot.key == "0" {
                        continue
                    }
                    children.append(SnapToSubject(snap: childSnapshot))
                }
                self.arrivedSubjects(subjects: children)
            } else if school != nil {
                var counter : Int = 0
                var children : [SubjectItem] = []
                for child in snapshot.children {
                    counter += 1
                    let childSnap = child as! DataSnapshot
                    Database.database().reference()
                        .child("Materias")
                        .child(childSnap.key)
                        .observeSingleEvent(of: .value, with: { (snapshot) in
                            counter -= 1
                            if !(snapshot.value is NSNull) {
                                children.append(SnapToSubject(snap: snapshot))
                            }
                            if counter == 0 {
                                self.arrivedSubjects(subjects: children)
                            }
                        })
                }
            } else {
                self.arrivedSubjects(subjects: [SnapToSubject(snap: snapshot)])
            }
        })
    }
}

protocol AddSubject {
    func finishedSend(success: Bool)
}

extension AddSubject {
    func add(subj: SubjectItem) {
        let ref = Database.database().reference()
        let dict : [String : Any] = [
            "classId": 0 as Any,
            "erase" : false as Any,
            "facultadId" : subj.Facultad as Any,
            "facultadName" : subj.FacultadName as Any,
            "name" : subj.ShownName as Any,
            "prof" : subj.prof as Any,
            "timestamp" : Int(Date().timeIntervalSince1970 * 1000.0) as Any
        ]
        ref
            .child("ClassAddRequests")
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
