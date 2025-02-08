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

struct GetUserSubjectsResponse: Decodable {
    let userSubjects: [UserSubject]
}
