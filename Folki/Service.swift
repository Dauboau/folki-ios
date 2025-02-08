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

func getMe(token: String) -> User{
    
    let response = Just.get(url + "/users/me/", headers: ["Authorization": "Bearer \(token)"])
    
    let jsonStr = response.text
    let jsonData = (jsonStr?.data(using: .utf8)!)!
    
    let getMeResponse : GetMeResponse = try! JSONDecoder().decode(GetMeResponse.self, from: jsonData)
    
    return getMeResponse.user
    
}

func getUserSubjects(token: String) -> [UserSubject]{
    
    let response = Just.get(url + "/users/me/subjects", headers: ["Authorization": "Bearer \(token)"])
    
    let jsonStr = response.text
    let jsonData = (jsonStr?.data(using: .utf8)!)!
    
    let getUserSubjectsResponse : GetUserSubjectsResponse = try! JSONDecoder().decode(GetUserSubjectsResponse.self, from: jsonData)
    
    return getUserSubjectsResponse.userSubjects
    
}
