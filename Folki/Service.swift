//
//  Service.swift
//  PetHouse
//
//  Created by Student07 on 24/03/23.
//

import Foundation
import Just

let url = "https://api.folki.com.br/api"

struct LoginResponse: Decodable {
    let token: String
}

func login(uspCode: String, password: String, universityId: Int, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
    // Create the request body
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
