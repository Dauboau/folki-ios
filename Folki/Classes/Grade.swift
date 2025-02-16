//
//  Grade.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 15/02/25.
//

import Foundation

class Grade: Decodable,Equatable {
    
    // Properties
    var id: Int
    var name: String;
    var value: Float;
    var percentage: Float;
    
    // Initializer
    init(id: Int, name: String, value: Float, percentage: Float) {
        self.id = id
        self.name = name
        self.value = value
        self.percentage = percentage
    }
    
    // Equatable conformance
    static func ==(lhs: Grade, rhs: Grade) -> Bool {
        return lhs.id == rhs.id
    }
    
}
