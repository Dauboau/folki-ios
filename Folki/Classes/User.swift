//
//  Classes.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 07/02/25.
//

import Foundation
import SwiftData

@Model
class User: Decodable,Equatable {
    
    // Properties
    @Attribute(.unique) var id: Int?
    var email: String?
    var name: String?
    var instituteId: Int?
    var courseId: Int?
    var isVerified: Bool?
    var institute: Institute?
    var notificationId: String?
    var userVersion: String?
    var university: University?
    
    // Initializer
    init(id: Int, email: String, name: String, instituteId: Int? = nil, courseId: Int? = nil, isVerified: Bool? = nil, institute: Institute? = nil, notificationId: String? = nil, userVersion: String? = nil, university: University? = nil) {
            self.id = id
            self.email = email
            self.name = name
            self.instituteId = instituteId
            self.courseId = courseId
            self.isVerified = isVerified
            self.institute = institute
            self.notificationId = notificationId
            self.userVersion = userVersion
            self.university = university
    }

    // Decodable conformance
    enum CodingKeys: String, CodingKey {
        case id, email, name, instituteId, courseId, isVerified, institute, notificationId, userVersion, university
    }
    
    required convenience init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let id = try container.decode(Int.self, forKey: .id)
            let email = try container.decode(String.self, forKey: .email)
            let name = try container.decode(String.self, forKey: .name)
            let instituteId = try container.decodeIfPresent(Int.self, forKey: .instituteId)
            let courseId = try container.decodeIfPresent(Int.self, forKey: .courseId)
            let isVerified = try container.decodeIfPresent(Bool.self, forKey: .isVerified)
            let institute = try container.decodeIfPresent(Institute.self, forKey: .institute)
            let notificationId = try container.decodeIfPresent(String.self, forKey: .notificationId)
            let userVersion = try container.decodeIfPresent(String.self, forKey: .userVersion)
            let university = try container.decodeIfPresent(University.self, forKey: .university)
            
            self.init(id: id, email: email, name: name, instituteId: instituteId, courseId: courseId, isVerified: isVerified, institute: institute, notificationId: notificationId, userVersion: userVersion, university: university)
        }
    
}
