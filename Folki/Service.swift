//
//  Service.swift
//  PetHouse
//
//  Created by Student07 on 24/03/23.
//

import Foundation
import Just

let url = "https://api.folki.com.br/api"

func login(uspCode: String, password: String, universityId: Int) -> String {
    
    let body: [String: Any] = [
        "uspCode": uspCode,
        "password": password,
        "universityId": universityId
    ]
    
    let response = Just.post(url + "/users/auth", json: body)
    
    let jsonStr = response.text
    let jsonData = (jsonStr?.data(using: .utf8)!)!
    
    let loginResponse : LoginResponse = try! JSONDecoder().decode(LoginResponse.self, from: jsonData)
    
    return loginResponse.token
    
}

func getMe(token: String) -> User{
    
    let response = Just.get(url + "/users/me/", headers: ["Authorization": "Bearer \(token)"])
    
    let jsonStr = response.text
    let jsonData = (jsonStr?.data(using: .utf8)!)!
    
    let getMeResponse : GetMeResponse = try! JSONDecoder().decode(GetMeResponse.self, from: jsonData)
    
    return getMeResponse.user
    
}



@MainActor
class Api : ObservableObject {
    
    @Published var token:String = ""
    
    @Published var user:User = User(id: nil, email: nil, name: nil, instituteId: nil, courseId: nil, isVerified: nil, institute: nil, notificationId: nil, userVersion: nil, university: nil)
    
    func loginApi(uspCode: String, password: String, universityId: Int){
        
        Task.detached{
            
            let token = login(uspCode: uspCode, password: password, universityId: universityId)
            
            await MainActor.run{
                self.token = token
            }
            
        }
        
    }
    
    func getMeApi(token: String){
            
        Task.detached{
            
            let user = getMe(token:token)
            
            await MainActor.run{
                self.user = user
            }
            
        }
        
    }
    
}
