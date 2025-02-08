//
//  Classes.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 07/02/25.
//

import Foundation

struct LoginResponse: Decodable {
    let token: String
}

struct GetMeResponse: Decodable {
    let user: User
}

struct User: Decodable,Equatable {
    var id: Int?
    var email: String?
    var name: String?
    var instituteId: Int?
    var courseId: Int?
    var isVerified: Bool?
    var institute: Institute?
    var notificationId: String?
    var userVersion: String?
    var university: University?
}

struct Institute: Decodable,Equatable {
    var id: Int
    var name: String
    var campusId: Int?
}

struct University: Decodable,Equatable {
    var id: Int
    var name: String
    var slug: String
}
