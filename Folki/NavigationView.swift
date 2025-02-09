//
//  ContentView.swift
//  PetHouse
//
//  Created by Student07 on 21/03/23.
//

import SwiftUI
import SwiftData

struct NavigationView: View {
    
    let token : String? = UserDefaults.standard.string(forKey: "token")
    
    //@State private var customization: TabViewCustomization
    
    @Environment(\.modelContext) var context
    @Query() private var users: [User]
    var user: User { users.first ?? Default.user }
    
    @Query(sort: \UserSubject.id) private var userSubjects: [UserSubject]
    
    var body: some View {
        
        NavigationStack {
                
            TabView {
                
                Home(user: user)
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
                
                Faltas(userSubjects: userSubjects)
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
            .tint(Color("Primary_Purple"))
            .onAppear {
                
                Task.detached{
                    
                    // Get user data
                    let userAux = getMe(token: token!)
                    
                    // Get userSubjects
                    let userSubjectsAux = getUserSubjects(token: token!)
                
                    await MainActor.run{
                        
                        if user == userAux {
                            user.update(user: userAux)
                        }else{
                            context.insert(userAux)
                        }
                        
                        for userSubjectAux in userSubjectsAux {
                            
                            var userSubjectFound = false
                            for userSubject in userSubjects {
                                if(userSubject == userSubjectAux){
                                    userSubjectFound = true
                                    userSubject.update(userSubject: userSubjectAux)
                                    break
                                }
                            }
                            
                            if(!userSubjectFound){
                                context.insert(userSubjectAux)
                            }
                            
                        }
                        
                        // Save to persist the user
                        do {
                            try context.save()
                        } catch {
                            print("Error saving context: \(error)")
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
        NavigationView()
            .modelContainer(for:User.self, inMemory: true)
    }
}
