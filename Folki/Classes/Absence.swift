//
//  Absence.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 15/02/25.
//

import Foundation

class Absence: Decodable,Equatable {
    
    // Properties
    var id: Int
    var date: String
    
    // Initializer
    init(id: Int, date: String) {
        self.id = id
        self.date = date
    }
    
    // Equatable conformance
    static func ==(lhs: Absence, rhs: Absence) -> Bool {
        return lhs.id == rhs.id
    }
    
}
