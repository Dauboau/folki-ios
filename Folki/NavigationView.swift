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
    
    // Tab View
    @AppStorage("customization") private var customization: TabViewCustomization = TabViewCustomization()
    init() {
        UITabBar.appearance().barStyle = .black
        UITabBar.appearance().backgroundColor = UIColor(Color(DefaultBackground.color))
    }
    
    var body: some View {
        
        NavigationStack {
                
            TabView {
                
                Tab("Início", systemImage: "house.fill") {
                    Home(user: user)
                }
                .customizationID("com.myApp.home")
                
                Tab("Semana", systemImage: "list.bullet") {
                    LoginMenu()
                }
                .customizationID("com.myApp.week")
                .defaultVisibility(.hidden, for: .tabBar)
                
                Tab("Calendário", systemImage: "calendar") {
                    LoginMenu()
                }
                .customizationID("com.myApp.calendar")
                
                Tab("Atividades", systemImage: "bookmark.fill") {
                    LoginMenu()
                }
                .customizationID("com.myApp.activities")
                
                if UIDevice.current.userInterfaceIdiom != .phone {
                    Tab("Faltas", systemImage: "bag.fill") {
                        Absences(userSubjects: userSubjects)
                    }
                    .customizationID("com.myApp.absences")
                    
                    Tab("Notas", systemImage: "tray.full.fill") {
                        Grade(userSubjects: userSubjects)
                    }
                    .customizationID("com.myApp.grades")
                }
                
                Tab("Subjects", systemImage: "books.vertical.fill") {
                    SubjectsHub(userSubjects:userSubjects)
                }
                .customizationID("com.myApp.subjects")
                .defaultVisibility(.hidden, for: .automatic)
                
                Tab("Configurações", systemImage: "gearshape") {
                    Settings()
                }
                .customizationID("com.myApp.settings")
                
            }
            .tabViewStyle(.sidebarAdaptable)
            .tabViewCustomization($customization)
            .tint(Color("Primary_Purple"))
            .onAppear {
                
                Task.detached(){
                    
                    // Get user data
                    let userAux = getMe(token: token!)
                    
                    // Get userSubjects
                    let userSubjectsAux = getUserSubjects(token: token!)
                    
                    if(
                        userAux == nil
                        || userSubjectsAux == nil
                    ){
                        return
                    }
                
                    await MainActor.run{
                        
                        if user == userAux {
                            user.update(user: userAux!)
                        }else{
                            context.insert(userAux!)
                        }
                        
                        // Inserting and Updating
                        for userSubjectAux in userSubjectsAux! {
                            
                            var userSubjectFound = false
                            for userSubject in userSubjects {
                                if(userSubject == userSubjectAux){
                                    print("\(userSubject.subjectClass.subject.name) updated!")
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
