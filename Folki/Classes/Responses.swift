//
//  Classes.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 07/02/25.
//

import Foundation

class LoginResponse: Decodable {
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

class GetGradesResponse: Decodable {
    let grades: [Grade]
}

class GetAbsencesResponse: Decodable {
    let absences: [Absence]
}

class DeleteAbsenceResponse: Decodable {
    let succesful: Bool
}

class DeleteGradeResponse: Decodable {
    let succesful: Bool
}

class CheckActivityResponse: Decodable {
    let check: Check
}

class UncheckActivityResponse: Decodable {
    let activity: Activity
}

class Cache {
    
    static let shared = Cache()
    private init() {}
    
    private let cacheGetMeResponse = NSCache<NSString, GetMeResponse>()
    private let cacheGetUserSubjectsResponse = NSCache<NSString, GetUserSubjectsResponse>()
    private let cacheGetUserActivitiesResponse = NSCache<NSString, GetUserActivitiesResponse>()
    private let cacheGetGradesResponse = NSCache<NSNumber, GetGradesResponse>()
    private let cacheGetAbsencesResponse = NSCache<NSNumber, GetAbsencesResponse>()
    
    // User (GetMeResponse)
    func getCacheGetMeResponse(forToken token: String) -> GetMeResponse? {
        return cacheGetMeResponse.object(forKey: token as NSString)
    }
    func setCacheGetMeResponse(_ getMeResponse: GetMeResponse, forToken token: String) {
        cacheGetMeResponse.setObject(getMeResponse, forKey: token as NSString)
    }
    func invalidateCacheGetMeResponse(forToken token: String) -> Void {
        return cacheGetMeResponse.removeObject(forKey: token as NSString)
    }
    
    // [UserSubject] (GetUserSubjectsResponse)
    func getCacheGetUserSubjectsResponse(forToken token: String) -> GetUserSubjectsResponse? {
        return cacheGetUserSubjectsResponse.object(forKey: token as NSString)
    }
    func setCacheGetUserSubjectsResponse(_ getUserSubjectsResponse: GetUserSubjectsResponse, forToken token: String) {
        cacheGetUserSubjectsResponse.setObject(getUserSubjectsResponse, forKey: token as NSString)
    }
    func invalidateCacheGetUserSubjectsResponse(forToken token: String) -> Void {
        return cacheGetUserSubjectsResponse.removeObject(forKey: token as NSString)
    }
    
    // [Activity] (GetUserActivitiesResponse)
    func getCacheGetUserActivitiesResponse(forToken token: String) -> GetUserActivitiesResponse? {
        return cacheGetUserActivitiesResponse.object(forKey: token as NSString)
    }
    func setCacheGetUserActivitiesResponse(_ getUserActivitiesResponse: GetUserActivitiesResponse, forToken token: String) {
        cacheGetUserActivitiesResponse.setObject(getUserActivitiesResponse, forKey: token as NSString)
    }
    func invalidateCacheGetUserActivitiesResponse(forToken token: String) -> Void {
        return cacheGetUserActivitiesResponse.removeObject(forKey: token as NSString)
    }
    
    // [Grade] (GetGradesResponse)
    func getCacheGetGradesResponse(forSubjectId subjectId: Int) -> GetGradesResponse? {
        return cacheGetGradesResponse.object(forKey: subjectId as NSNumber)
    }
    func setCacheGetGradesResponse(_ getUserActivitiesResponse: GetGradesResponse, forSubjectId subjectId: Int) {
        cacheGetGradesResponse.setObject(getUserActivitiesResponse, forKey: subjectId as NSNumber)
    }
    func invalidateCacheGetGradesResponse(forSubjectId subjectId: Int) -> Void? {
        return cacheGetGradesResponse.removeObject(forKey: subjectId as NSNumber)
    }
    
    // [Absence] (GetAbsencesResponse)
    func getCacheGetAbsencesResponse(forSubjectId subjectId: Int) -> GetAbsencesResponse? {
        return cacheGetAbsencesResponse.object(forKey: subjectId as NSNumber)
    }
    func setCacheGetAbsencesResponse(_ getAbsencesResponse: GetAbsencesResponse, forSubjectId subjectId: Int) {
        cacheGetAbsencesResponse.setObject(getAbsencesResponse, forKey: subjectId as NSNumber)
    }
    func invalidateCacheGetAbsencesResponse(forSubjectId subjectId: Int) -> Void {
        return cacheGetAbsencesResponse.removeObject(forKey: subjectId as NSNumber)
    }
    
}
