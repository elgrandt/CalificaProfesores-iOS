//
//  Schools.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 25/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import Firebase

class SchoolItem {
    var id : String?
    var CompleteName : String?
    var Name : String?
    var ShownName : String?
}

protocol SchoolNetwork {
    func arrivedSchools(schools : [SchoolItem])
}

func SnapToSchool(snap: DataSnapshot) -> SchoolItem {
    let dict = snap.value as! NSDictionary
    let current = SchoolItem()
    current.id = snap.key
    current.CompleteName = dict["CompleteName"] as? String
    current.Name = dict["Name"] as? String
    current.ShownName = dict["ShownName"] as? String
    return current
}

extension SchoolNetwork {
    func searchSchools(keyword : String? = nil, hash : String? = nil) {
        var query : DatabaseQuery?
        if keyword != nil {
            let keywordModified = keyword!.lowercased()
                .replacingOccurrences(of: "á", with: "a")
                .replacingOccurrences(of: "é", with: "e")
                .replacingOccurrences(of: "í", with: "i")
                .replacingOccurrences(of: "ó", with: "o")
                .replacingOccurrences(of: "ú", with: "u")
            query = Database.database().reference()
                .child("Facultades")
                .queryOrdered(byChild: "Name")
                .queryStarting(atValue: keywordModified)
                .queryEnding(atValue: keywordModified + "\u{f8ff}")
        } else {
            query = Database.database().reference()
                .child("Facultades")
                .child(hash!)
        }
        
        query!.observeSingleEvent(of: .value, with: { (snapshot) in
            if keyword != nil {
                var children : [SchoolItem] = []
                for child in snapshot.children {
                    let childSnapshot = child as! DataSnapshot
                    if childSnapshot.key == "0" {
                        continue
                    }
                    children.append(SnapToSchool(snap: childSnapshot))
                }
                self.arrivedSchools(schools: children)
            } else {
                self.arrivedSchools(schools: [SnapToSchool(snap: snapshot)])
            }
        })
    }
}

struct SchoolAddRequest {
    var erase : Bool?
    var timestamp : Int?
    var uniCompleteName : String?
    var uniShortName : String?
}

protocol AddSchool {
    func finishedSend(success: Bool)
}

extension AddSchool {
    func add(school: SchoolAddRequest) {
        let ref = Database.database().reference()
        let dict : [String : Any] = [
            "erase" : school.erase as Any,
            "timestamp" : school.timestamp as Any,
            "uniCompleteName" : school.uniCompleteName as Any,
            "uniShortName" : school.uniShortName as Any
        ]
        ref
            .child("UniAddRequests")
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
