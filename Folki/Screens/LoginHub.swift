//
//  LoginHub.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 08/02/25.
//

import SwiftUI

/**
 Hub for waiting the login process
 */
struct LoginHub: View {
    
    @Environment(\.dismiss) private var dismiss
    
    // Login Requirements
    @State var studentRA : String
    @State var studentPassword : String
    @State var universityId : Int
    
    @State var loginFlag : Bool = true
    
    @State private var errorFlag = false
    
    var body: some View {
        
        NavigationStack {
            
            if loginFlag {
                
                ZStack{
                    
                    Color.gray2
                        .ignoresSafeArea()
                    
                    LoginLoading()
                        .alert("Erro de Login", isPresented: $errorFlag, actions: {
                            Button("Tentar Novamente") {
                                dismiss()
                            }
                        }, message: {
                            Text("Ocorreu um erro ao tentar fazer login. Por favor, verifique suas credenciais e tente novamente.")
                        })
                        .onAppear{
                            
                            // checks conditions
                            if(
                                studentRA.isEmpty
                                || studentPassword.isEmpty
                            ){
                                errorFlag = true
                                return
                            }
                            
                            login(uspCode: studentRA, password: studentPassword, universityId: universityId) { result in
                                switch result {
                                case .success(let loginResponse):
                                    print("Login successful! Token: \(loginResponse.token)")
                                    
                                    UserDefaults.standard.set(loginResponse.token, forKey: "token")
                                    
                                    loginFlag = false
                                    
                                case .failure(let error):
                                    print("Login failed: \(error.localizedDescription)")
                                    
                                    errorFlag = true
                                    return
                                }
                                
                            }
                            
                        }
                    
                }
                
            }else{
                
                NavigationView()
                
            }
            
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    LoginHub(studentRA: "12547614", studentPassword: "bymxox-tubTed-1jufpu", universityId: 1)
}

/**
 Loading indicator view
 */
fileprivate struct LoginLoading: View {
    var body: some View {
        
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(2, anchor: .center)
            .tint(Color("Primary_Purple"))
        
    }
}
