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
    var userSubjectId: Int
    
    // Initializer
    init(id: Int, date: String, userSubjectId: Int) {
        self.id = id
        self.date = date
        self.userSubjectId = userSubjectId
    }
    
    // Equatable conformance
    static func ==(lhs: Absence, rhs: Absence) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Decodable conformance
    enum CodingKeys: String, CodingKey {
        case id, date, userSubjectId
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let date = try container.decode(String.self, forKey: .date)
        let userSubjectId = try container.decode(Int.self, forKey: .userSubjectId)
        
        self.init(id: id, date: date, userSubjectId: userSubjectId)
    }
    
    func update(_ absence: Absence) {
        self.date = absence.date
    }
    
    func getDate() -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        return isoFormatter.date(from: self.date)
    }
    
}
