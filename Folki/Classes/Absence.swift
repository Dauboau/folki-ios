//
//  Absence.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 15/02/25.
//

import Foundation
import SwiftData

@Model
class Absence: Decodable,Equatable {
    
    // Properties
    @Attribute(.unique) var id: Int
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
    
    // Decodable conformance
    enum CodingKeys: String, CodingKey {
        case id, date
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let date = try container.decode(String.self, forKey: .date)
        
        self.init(id: id, date: date)
    }
    
    func update(absence: Absence) {
        self.date = absence.date
    }
    
}
