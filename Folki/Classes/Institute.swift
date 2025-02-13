//
//  Classes.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 07/02/25.
//

import Foundation
import SwiftData

@Model
class Institute: Decodable,Equatable {
    
    // Properties
    var id: Int
    var name: String
    var campusId: Int?
    
    // Initializer
    init(id: Int, name: String, campusId: Int? = nil) {
        self.id = id
        self.name = name
        self.campusId = campusId
    }
    
    // Equatable conformance
    static func ==(lhs: Institute, rhs: Institute) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Decodable conformance
    enum CodingKeys: String, CodingKey {
        case id, name, campusId
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let campusId = try container.decodeIfPresent(Int.self, forKey: .campusId)
        
        self.init(id: id, name: name, campusId: campusId)
    }
    
    func update(institute : Institute){
        self.id = institute.id
        self.name = institute.name
        self.campusId = institute.campusId
    }
    
}
