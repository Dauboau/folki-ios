//
//  ContentView.swift
//  PetHouse
//
//  Created by Student07 on 21/03/23.
//

import SwiftUI
import SwiftData

struct NavigationView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var studentRA : String
    @State var studentPassword : String
    @State var universityId : Int
    @State var loginFlag : Bool = false
    
    @State var token : String? = UserDefaults.standard.string(forKey: "token")
    
    @Environment(\.modelContext) var context
    @Query() private var users: [User]
    var user: User? { users.first }
    
    var body: some View {
        
        NavigationStack {
            
            if token == nil || loginFlag {
                
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
                                token = loginResponse.token
                                
                                loginFlag = false
                                
                            case .failure(let error):
                                print("Login failed: \(error.localizedDescription)")
                                
                                DispatchQueue.main.async {
                                    dismiss()
                                }
                            }
                            
                        }
                        
                    }
                
            } else {
                
                TabView {
                    
                    Home(user: user ?? Default.user)
                        .tabItem {
                            Label("Início", systemImage: "house.fill")
                        }
                    
                    LoginMenu()
                        .tabItem {
                            Label("Semana", systemImage: "list.bullet")
                        }
                    
                    LoginMenu()
                        .tabItem {
                            Label("Calendário", systemImage: "calendar")
                        }
                    
                    LoginMenu()
                        .tabItem {
                            Label("Atividades", systemImage: "bookmark.fill")
                        }
                    
                    LoginMenu()
                        .tabItem {
                            Label("Faltas", systemImage: "bag.fill")
                        }
                    
                    LoginMenu()
                        .tabItem {
                            Label("Notas", systemImage: "tray.full.fill")
                        }
                    
                    LoginMenu()
                        .tabItem {
                            Label("Configurações", systemImage: "gearshape")
                        }
                    
                }
                .tabViewStyle(.automatic)
                .tint(Color("Primary_Purple"))
                .onAppear {
                    
                    Task.detached{
                        
                        // Get user data
                        let userAux = await getMe(token: token!)
                        
                        await MainActor.run{
                            
                            context.insert(userAux)
                            
                            // Save to persist the user
                            do {
                                try context.save()
                                print("User inserted and saved!")
                            } catch {
                                print("Error saving context: \(error)")
                            }
                            
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
        NavigationView(studentRA: "12547614", studentPassword: "bymxox-tubTed-1jufpu", universityId: 1)
            .modelContainer(for:User.self, inMemory: true)
    }
}
