//
//  Classes.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 07/02/25.
//

import Foundation
import SwiftData

@Model
class University: Decodable,Equatable {
    
    // Properties
    var id: Int
    var name: String
    var slug: String
    
    // Static
    static let Dates: [Int: [Date]] = [
        1: [Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 12))!],
        2: [Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 14))!,
            Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 7))!]
    ]
    
    // Initializer
    init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
    
    // Equatable conformance
    static func ==(lhs: University, rhs: University) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Decodable conformance
    enum CodingKeys: String, CodingKey {
        case id, name, slug
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let slug = try container.decode(String.self, forKey: .slug)
        
        self.init(id: id, name: name, slug: slug)
    }
    
    func update(university : University){
        self.id = university.id
        self.name = university.name
        self.slug = university.slug
    }
    
    func calculateSemester() -> Int {
        let today = Date()
        guard let dates = University.Dates[self.id] else {
            return 0
        }
        
        let start = dates[0]
        let end = dates[1]
        
        let total = end.timeIntervalSince(start)
        let current = today.timeIntervalSince(start)
        
        let percentage = (current / total) * 100
        return Int(min(max(floor(percentage), 0), 100))
    }
    
}
