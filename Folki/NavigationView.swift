//
//  ContentView.swift
//  PetHouse
//
//  Created by Student07 on 21/03/23.
//

import SwiftUI

struct NavigationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var studentRA : String
    @State var studentPassword : String
    @State var universityId : Int
    @State var loginFlag : Bool = false
    @State var user : User?
    
    var body: some View {
        
        NavigationStack {
            
            if UserDefaults.standard.string(forKey: "token") == nil || loginFlag {
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2, anchor: .center)
                    .tint(Color("Primary_Purple"))
                    .onAppear{
                        
                        login(uspCode: studentRA, password: studentPassword, universityId: universityId) { result in
                            switch result {
                            case .success(let loginResponse):
                                print("Login successful! Token: \(loginResponse.token)")
                                
                                UserDefaults.standard.set(loginResponse.token, forKey: "token")
                                
                                loginFlag = false
                                
                            case .failure(let error):
                                print("Login failed: \(error.localizedDescription)")
                                
                                DispatchQueue.main.async {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                            
                        }
                        
                    }
                
            }else{
                
                TabView{
                    
                    Home(user: user)
                        .tabItem {
                            Label("Início",systemImage: "house.fill")
                        }
                    
                    LoginMenu()
                        .tabItem {
                            Label("Semana",systemImage: "list.bullet")
                        }
                    
                    LoginMenu()
                        .tabItem {
                            Label("Calendário",systemImage: "calendar")
                            
                        }
                    
                    LoginMenu()
                        .tabItem {
                            Label("Atividades",systemImage: "bookmark.fill")
                        }
                    
                    LoginMenu()
                        .tabItem {
                            Label("Faltas",systemImage: "bag.fill")
                        }
                    
                    LoginMenu()
                        .tabItem {
                            Label("Notas",systemImage: "tray.full.fill")
                        }
                    
                    LoginMenu()
                        .tabItem {
                            Label("Configurações",systemImage: "gearshape")
                        }
                    
                }
                .tabViewStyle(.automatic)
                .tint(Color("Primary_Purple"))
                .onAppear{
                    
                    getMe(token: UserDefaults.standard.string(forKey: "token")!) { result in
                        switch result {
                        case .success(let getMeResponse):
                            print("GetMe successful! User: \(getMeResponse.user)")
                            user = getMeResponse.user
                        case .failure(let error):
                            print("GetMe failed: \(error.localizedDescription)")
                        }
                        
                    }
                    
                }
                
            }
            
        }
        .navigationBarBackButtonHidden(true)
        
    }

}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(studentRA: "12547614", studentPassword: "bymxox-tubTed-1jufpu",universityId:1)
    }
}
