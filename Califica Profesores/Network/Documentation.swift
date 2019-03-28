//
//  Documentation.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 28/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import Firebase

protocol DocumentationNetwork {
    func arrivedResults(results: [String])
}

extension DocumentationNetwork {
    func getPrivacyPolicies() {
        Database.database().reference()
        .child("PrivacyPolicies")
        .observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? [String]
            if data != nil {
                self.arrivedResults(results: data!)
            }
        }
    }
    
    func getAttributions() {
        Database.database().reference()
            .child("Attributions")
            .observeSingleEvent(of: .value) { (snapshot) in
                let data = snapshot.value as? [String]
                if data != nil {
                    self.arrivedResults(results: data!)
                }
        }
    }
}
