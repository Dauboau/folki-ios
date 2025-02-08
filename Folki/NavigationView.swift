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
    
    @Environment(\.modelContext) var context
    @Query() private var users: [User]
    var user: User { users.first ?? Default.user }
    
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
                    let userAux = getMe(token: token!)
                    
                    await MainActor.run{
                        
                        context.insert(userAux)
                        
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
