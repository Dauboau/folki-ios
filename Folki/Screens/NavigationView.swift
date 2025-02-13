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
    
    // Disciplinas ordenadas por ordem alfabética
    @Query(sort: \UserSubject.subjectClass.subject.name) private var userSubjects: [UserSubject]
    
    // Atividades ordenadas pela data de entrega
    @Query(sort: \Activity.finishDate) private var activities: [Activity]
    
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
                    Home(user: user, activities: activities, userSubjects: userSubjects)
                }
                .customizationID("com.myApp.home")
                
                if UIDevice.current.userInterfaceIdiom != .phone {
                    Tab("Semana", systemImage: "list.bullet") {
                        Week(userSubjects: userSubjects)
                    }
                    .customizationID("com.myApp.week")
                    
                    Tab("Calendário", systemImage: "calendar") {
                        LoginMenu()
                    }
                    .customizationID("com.myApp.calendar")
                }
                
                Tab("Agenda", systemImage: "calendar.badge.clock") {
                    ScheduleHub(userSubjects: userSubjects)
                }
                .customizationID("com.myApp.schedule")
                .defaultVisibility(.hidden, for: .sidebar)
                
                Tab("Atividades", systemImage: "bookmark.fill") {
                    Activities(activities: activities)
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
                
                Tab("Disciplinas", systemImage: "books.vertical.fill") {
                    SubjectsHub(userSubjects:userSubjects)
                }
                .customizationID("com.myApp.subjects")
                .defaultVisibility(.hidden, for: .sidebar)
                
                Tab("Configurações", systemImage: "gearshape.fill") {
                    Settings()
                }
                .customizationID("com.myApp.settings")
                
            }
            .tabViewStyle(.sidebarAdaptable)
            .tabViewCustomization($customization)
            .tint(Color("Primary_Purple"))
            .onAppear {
                
                Task.detached(){
                    
                    // Get user
                    let userAux = getMe(token: token!)
                    
                    // Get userSubjects
                    let userSubjectsAux = getUserSubjects(token: token!)
                    
                    // Get activities
                    let activitiesAux = getUserActivities(token: token!)
                    
                    if(
                        userAux == nil
                        || userSubjectsAux == nil
                        || activitiesAux == nil
                    ){
                        return
                    }
                
                    await MainActor.run{
                        
                        // Inserting and Updating user
                        if user == userAux {
                            user.update(user: userAux!)
                        }else{
                            context.insert(userAux!)
                        }
                        
                        // Inserting and Updating userSubjects
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
                                print("\(userSubjectAux.subjectClass.subject.name) created!")
                                context.insert(userSubjectAux)
                            }
                            
                        }
                        
                        // Inserting and Updating activities
                        for activityAux in activitiesAux! {
                            
                            var activityFound = false
                            for activity in activities {
                                if(activity == activityAux){
                                    print("\(activity.name) updated!")
                                    activityFound = true
                                    activity.update(activity: activityAux)
                                    break
                                }
                            }
                            
                            if(!activityFound){
                                print("\(activityAux.name) created!")
                                context.insert(activityAux)
                            }
                            
                        }
                        
                        // Save to persist the user data
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
