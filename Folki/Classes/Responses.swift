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

class GetMeResponse: Decodable {
    let user: User
}

class GetUserSubjectsResponse: Decodable {
    let userSubjects: [UserSubject]
}

class GetUserActivitiesResponse: Decodable {
    let activities: [Activity]
}

class Cache {
    
    static let shared = Cache()
    private init() {}
    
    private let cacheGetMeResponse = NSCache<NSString, GetMeResponse>()
    private let cacheGetUserSubjectsResponse = NSCache<NSString, GetUserSubjectsResponse>()
    private let cacheGetUserActivitiesResponse = NSCache<NSString, GetUserActivitiesResponse>()
    
    // User (GetMeResponse)
    func getCacheGetMeResponse(forToken token: String) -> GetMeResponse? {
        return cacheGetMeResponse.object(forKey: token as NSString)
    }
    func setCacheGetMeResponse(_ getMeResponse: GetMeResponse, forToken token: String) {
        cacheGetMeResponse.setObject(getMeResponse, forKey: token as NSString)
    }
    
    // [UserSubject] (GetUserSubjectsResponse)
    func getCacheGetUserSubjectsResponse(forToken token: String) -> GetUserSubjectsResponse? {
        return cacheGetUserSubjectsResponse.object(forKey: token as NSString)
    }
    func setCacheGetUserSubjectsResponse(_ getUserSubjectsResponse: GetUserSubjectsResponse, forToken token: String) {
        cacheGetUserSubjectsResponse.setObject(getUserSubjectsResponse, forKey: token as NSString)
    }
    
    // [Activity] (GetUserActivitiesResponse)
    func getCacheGetUserActivitiesResponse(forToken token: String) -> GetUserActivitiesResponse? {
        return cacheGetUserActivitiesResponse.object(forKey: token as NSString)
    }
    func setCacheGetUserActivitiesResponse(_ getUserActivitiesResponse: GetUserActivitiesResponse, forToken token: String) {
        cacheGetUserActivitiesResponse.setObject(getUserActivitiesResponse, forKey: token as NSString)
    }
    
}
