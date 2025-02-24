//
//  Service.swift
//  PetHouse
//
//  Created by Student07 on 24/03/23.
//

import Foundation
import Just

let url = "https://api.folki.com.br/api"

func login(uspCode: String, password: String, universityId: Int, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
    
    let body: [String: Any] = [
        "uspCode": uspCode,
        "password": password,
        "universityId": universityId
    ]
    
    Just.post(url + "/users/auth", json: body, asyncCompletionHandler:  { response in
        
        if let jsonStr = response.text {
            
            let jsonData = jsonStr.data(using: .utf8)!
            
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: jsonData)
                completion(.success(loginResponse))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(NSError(domain: "No response", code: 0, userInfo: nil)))
        }
    })
    
}

func getMe(token: String) -> User?{
    
    // Check Cache
    if let cacheResponse = Cache.shared.getCacheGetMeResponse(forToken: token){
        return cacheResponse.user
    }
    
    do {
        
        let response = Just.get(url + "/users/me/", headers: ["Authorization": "Bearer \(token)"])
        
        guard (200...299).contains(response.statusCode ?? 500) else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonStr = response.text else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonData = jsonStr.data(using: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        let getMeResponse: GetMeResponse = try JSONDecoder().decode(GetMeResponse.self, from: jsonData)
        
        // Cache the Response
        Cache.shared.setCacheGetMeResponse(getMeResponse, forToken: token)
        
        return getMeResponse.user
        
    } catch {
        print("An error occurred: \(error)")
        return nil
    }
    
}

func getUserSubjects(token: String) -> [UserSubject]? {
    
    // Check Cache
    if let cacheResponse = Cache.shared.getCacheGetUserSubjectsResponse(forToken: token){
        return cacheResponse.userSubjects
    }
    
    do {
        let response = Just.get(url + "/users/me/subjects", headers: ["Authorization": "Bearer \(token)"])
        
        guard (200...299).contains(response.statusCode ?? 500) else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonStr = response.text else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonData = jsonStr.data(using: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        let getUserSubjectsResponse: GetUserSubjectsResponse = try JSONDecoder().decode(GetUserSubjectsResponse.self, from: jsonData)
        
        // Cache the Response
        Cache.shared.setCacheGetUserSubjectsResponse(getUserSubjectsResponse, forToken: token)
        
        return getUserSubjectsResponse.userSubjects
        
    } catch {
        print("An error occurred: \(error)")
        return nil
    }
}

func getUserActivities(token: String) -> [Activity]? {
    
    // Check Cache
    if let cacheResponse = Cache.shared.getCacheGetUserActivitiesResponse(forToken: token){
        return cacheResponse.activities
    }
    
    do {
        let response = Just.get(url + "/activities", headers: ["Authorization": "Bearer \(token)"])
        
        guard (200...299).contains(response.statusCode ?? 500) else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonStr = response.text else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonData = jsonStr.data(using: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        let getUserActivitiesResponse: GetUserActivitiesResponse = try JSONDecoder().decode(GetUserActivitiesResponse.self, from: jsonData)
        
        // Cache the Response
        Cache.shared.setCacheGetUserActivitiesResponse(getUserActivitiesResponse, forToken: token)
        
        return getUserActivitiesResponse.activities
        
    } catch {
        print("An error occurred: \(error)")
        return nil
    }
    
}

func getGrades(token: String, subjectId: Int) -> [Grade]? {
    
    // Check Cache
    if let cacheResponse = Cache.shared.getCacheGetGradesResponse(forSubjectId: subjectId){
        return cacheResponse.grades
    }
    
    do {
        let response = Just.get(url + "/subjects/\(subjectId)/grades", headers: ["Authorization": "Bearer \(token)"])
        
        guard (200...299).contains(response.statusCode ?? 500) else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonStr = response.text else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonData = jsonStr.data(using: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        let getGradesResponse: GetGradesResponse = try JSONDecoder().decode(GetGradesResponse.self, from: jsonData)
        
        // Cache the Response
        Cache.shared.setCacheGetGradesResponse(getGradesResponse, forSubjectId: subjectId)
        
        return getGradesResponse.grades
        
    } catch {
        print("An error occurred: \(error)")
        return nil
    }
    
}

func getAbsences(token: String, subjectId: Int) -> [Absence]? {
    
    // Check Cache
    if let cacheResponse = Cache.shared.getCacheGetAbsencesResponse(forSubjectId: subjectId){
        return cacheResponse.absences
    }
    
    do {
        let response = Just.get(url + "/subjects/\(subjectId)/absences", headers: ["Authorization": "Bearer \(token)"])
        
        guard (200...299).contains(response.statusCode ?? 500) else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonStr = response.text else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonData = jsonStr.data(using: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        let getAbsencesResponse: GetAbsencesResponse = try JSONDecoder().decode(GetAbsencesResponse.self, from: jsonData)
        
        // Cache the Response
        Cache.shared.setCacheGetAbsencesResponse(getAbsencesResponse, forSubjectId: subjectId)
        
        return getAbsencesResponse.absences
        
    } catch {
        print("An error occurred: \(error)")
        return nil
    }
    
}

func deleteAbsence(token: String, absence: Absence) -> Bool? {
    
    do {
        let response = Just.delete(url + "/absences/\(absence.id)", headers: ["Authorization": "Bearer \(token)"])
        
        guard (200...299).contains(response.statusCode ?? 500) else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonStr = response.text else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonData = jsonStr.data(using: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        let deleteAbsenceResponse: DeleteAbsenceResponse = try JSONDecoder().decode(DeleteAbsenceResponse.self, from: jsonData)
        
        // Invalidate the Cache
        Cache.shared.invalidateCacheGetAbsencesResponse(forSubjectId: absence.userSubjectId)
        Cache.shared.invalidateCacheGetUserSubjectsResponse(forToken: token)
        
        return deleteAbsenceResponse.succesful
        
    } catch {
        print("An error occurred: \(error)")
        return nil
    }
    
}

func deleteGrade(token: String, grade: Grade) -> Bool? {
    
    do {
        let response = Just.delete(url + "/grades/\(grade.id)", headers: ["Authorization": "Bearer \(token)"])
        
        guard (200...299).contains(response.statusCode ?? 500) else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonStr = response.text else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonData = jsonStr.data(using: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        let deleteGradeResponse: DeleteGradeResponse = try JSONDecoder().decode(DeleteGradeResponse.self, from: jsonData)
        
        // Invalidate the Cache
        Cache.shared.invalidateCacheGetGradesResponse(forSubjectId: grade.userSubjectId)
        Cache.shared.invalidateCacheGetUserSubjectsResponse(forToken: token)
        
        return deleteGradeResponse.succesful
        
    } catch {
        print("An error occurred: \(error)")
        return nil
    }
    
}

func checkActivity(token: String, activity: Activity) -> Check? {
    
    do {
        let response = Just.post(url + "/activities/\(activity.id)/check", headers: ["Authorization": "Bearer \(token)"])
        
        guard (200...299).contains(response.statusCode ?? 500) else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonStr = response.text else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonData = jsonStr.data(using: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        let checkActivityResponse: CheckActivityResponse = try JSONDecoder().decode(CheckActivityResponse.self, from: jsonData)
        
        // Invalidate the Cache
        Cache.shared.invalidateCacheGetUserActivitiesResponse(forToken: token)
        
        return checkActivityResponse.check
        
    } catch {
        print("An error occurred: \(error)")
        return nil
    }
    
}

func uncheckActivity(token: String, activity: Activity) -> Activity? {
    
    do {
        let response = Just.delete(url + "/activities/\(activity.id)/check", headers: ["Authorization": "Bearer \(token)"])
        
        guard (200...299).contains(response.statusCode ?? 500) else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonStr = response.text else {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonData = jsonStr.data(using: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        let uncheckActivityResponse: UncheckActivityResponse = try JSONDecoder().decode(UncheckActivityResponse.self, from: jsonData)
        
        // Invalidate the Cache
        Cache.shared.invalidateCacheGetUserActivitiesResponse(forToken: token)
        
        return uncheckActivityResponse.activity
        
    } catch {
        print("An error occurred: \(error)")
        return nil
    }
    
}
