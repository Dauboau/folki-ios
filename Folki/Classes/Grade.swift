//
//  Grade.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 15/02/25.
//

import Foundation
import SwiftData

@Model
class Grade: Decodable,Equatable {
    
    // Properties
    @Attribute(.unique) var id: Int
    var userSubjectId: Int;
    var name: String;
    var value: Float;
    var percentage: Float;
    var createdAt: String;
    
    // Initializer
    init(id: Int, userSubjectId: Int, name: String, value: Float, percentage: Float, createdAt: String) {
        self.id = id
        self.userSubjectId = userSubjectId
        self.name = name
        self.value = value
        self.percentage = percentage
        self.createdAt = createdAt
    }
    
    // Equatable conformance
    static func ==(lhs: Grade, rhs: Grade) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Decodable conformance
    enum CodingKeys: String, CodingKey {
        case id, userSubjectId, name, value, percentage, createdAt
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let userSubjectId = try container.decode(Int.self, forKey: .userSubjectId)
        let name = try container.decode(String.self, forKey: .name)
        let value = try container.decode(Float.self, forKey: .value)
        let percentage = try container.decode(Float.self, forKey: .percentage)
        let createdAt = try container.decode(String.self, forKey: .createdAt)
        
        self.init(id: id, userSubjectId: userSubjectId,name: name, value: value, percentage: percentage, createdAt: createdAt)
    }
    
    func update(_ grade: Grade) {
        self.userSubjectId = grade.userSubjectId
        self.name = grade.name
        self.value = grade.value
        self.percentage = grade.percentage
        self.createdAt = grade.createdAt
    }
    
}
