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
    
    @StateObject var dataValidity = Cache.Validity()
    
    // Tab View
    @AppStorage("customization") private var customization: TabViewCustomization = TabViewCustomization()
    init() {
        UITabBar.appearance().barStyle = .black
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = UIColor(Color(DefaultBackground.color))
        if UIDevice.current.userInterfaceIdiom != .phone {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    var body: some View {
                
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
                    CalendarScreen(activities: activities)
                }
                .customizationID("com.myApp.calendar")
            }
            
            Tab("Agenda", systemImage: "calendar.badge.clock") {
                ScheduleHub(userSubjects: userSubjects, activities: activities)
            }
            .customizationID("com.myApp.schedule")
            .defaultVisibility(.hidden, for: .sidebar)
            
            Tab("Atividades", systemImage: "bookmark.fill") {
                Activities(activities: activities, userSubjects: userSubjects)
            }
            .customizationID("com.myApp.activities")
            
            if UIDevice.current.userInterfaceIdiom != .phone {
                Tab("Faltas", systemImage: "bag.fill") {
                    Absences(userSubjects: userSubjects)
                }
                .customizationID("com.myApp.absences")
                
                Tab("Notas", systemImage: "tray.full.fill") {
                    Grades(userSubjects: userSubjects)
                }
                .customizationID("com.myApp.grades")
            }
            
            Tab("Disciplinas", systemImage: "books.vertical.fill") {
                SubjectsHub(userSubjects:userSubjects)
            }
            .customizationID("com.myApp.subjects")
            .defaultVisibility(.hidden, for: .sidebar)
            
            Tab("Configurações", systemImage: "gearshape.fill") {
                Settings(user:user)
            }
            .customizationID("com.myApp.settings")
                
        }
        .navigationBarBackButtonHidden(true)
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($customization)
        .tint(Color("Primary_Purple"))
        
        .environmentObject(dataValidity)
        
        // Loads and Reloads data on demand (if invalid)
        .onChange(of: dataValidity.valid,initial: true){
            if(dataValidity.valid == false){
                updateData()
                dataValidity.valid = true
            }
        }
        
    }
    
    func updateData() {
        Task.detached(){
                        
            // Get user
            let userAux = getMe(token: token!)
            
            // Get userSubjects
            let userSubjectsAux = getUserSubjects(token: token!)
            
            // Get activities
            let activitiesAux = getUserActivities(token: token!)
            
            guard let userAuxNonNil = userAux,
                  let userSubjectsAuxNonNil = userSubjectsAux,
                  let activitiesAuxNonNil = activitiesAux else {
                return
            }
            
            nonisolated(unsafe) let UserAuxUnsafe = userAuxNonNil
            nonisolated(unsafe) let UserSubjectsAuxUnsafe = userSubjectsAuxNonNil
            nonisolated(unsafe) let ActivitiesAuxUnsafe = activitiesAuxNonNil
        
            await MainActor.run{
                
                do {
                    let currentUsersFD = FetchDescriptor<User>()
                    let currentUsers = try context.fetch(currentUsersFD)
                    
                    let currentUserSubjectsFD = FetchDescriptor<UserSubject>(
                        sortBy: [SortDescriptor(\UserSubject.subjectClass.subject.name)]
                    )
                    let currentUserSubjects = try context.fetch(currentUserSubjectsFD)
                    
                    let currentActivitiesFD = FetchDescriptor<Activity>(
                        sortBy: [SortDescriptor(\Activity.finishDate)]
                    )
                    let currentActivities = try context.fetch(currentActivitiesFD)
                
                    #if DEBUG
                    print(Default.separator)
                    #endif
                
                    // Inserting and Updating user
                    if let currentUser = currentUsers.first {
                        if currentUser == UserAuxUnsafe {
                            #if DEBUG
                            print("\(currentUser.name ?? "Usuário") updated!")
                            #endif
                            currentUser.update(user: UserAuxUnsafe)
                        } else {
                            #if DEBUG
                            print("\(UserAuxUnsafe.name ?? "Usuário") created!")
                            #endif
                            context.insert(UserAuxUnsafe)
                        }
                    } else {
                        #if DEBUG
                        print("\(UserAuxUnsafe.name ?? "Usuário") created!")
                        #endif
                        context.insert(UserAuxUnsafe)
                    }
                
                    // Inserting and Updating userSubjects
                    for userSubjectAux in UserSubjectsAuxUnsafe {
                        
                        var userSubjectFound = false
                        for userSubject in currentUserSubjects {
                            if(userSubject == userSubjectAux){
                                #if DEBUG
                                print("\(userSubject.subjectClass.subject.name) updated!")
                                #endif
                                userSubjectFound = true
                                userSubject.update(userSubject: userSubjectAux)
                                break
                            }
                        }
                        
                        if(!userSubjectFound){
                            #if DEBUG
                            print("\(userSubjectAux.subjectClass.subject.name) created!")
                            #endif
                            context.insert(userSubjectAux)
                        }
                        
                    }
                
                    // Inserting and Updating activities
                    for activityAux in ActivitiesAuxUnsafe {
                        
                        var activityFound = false
                        for activity in currentActivities {
                            if(activity == activityAux){
                                #if DEBUG
                                print("\(activity.name) updated!")
                                #endif
                                activityFound = true
                                activity.update(activity: activityAux)
                                break
                            }
                        }
                        
                        if(!activityFound){
                            #if DEBUG
                            print("\(activityAux.name) created!")
                            #endif
                            context.insert(activityAux)
                        }
                        
                    }
                
                    // Deleting activities
                    for activity in currentActivities {
                        if(!ActivitiesAuxUnsafe.contains(where: { $0 == activity })){
                            #if DEBUG
                            print("\(activity.name) deleted!")
                            #endif
                            context.delete(activity)
                        }
                    }
                
                    // Deleting userSubjects
                    for userSubject in currentUserSubjects {
                        if(!UserSubjectsAuxUnsafe.contains(where: { $0 == userSubject })){
                            #if DEBUG
                            print("\(userSubject.subjectClass.subject.name) deleted!")
                            #endif
                            context.delete(userSubject)
                        }
                    }
                
                    // Save to persist the user data
                    try context.save()
                
                    #if DEBUG
                    print(Default.separator)
                    #endif
                    
                } catch {
                    print("Error in updateData: \(error)")
                }
                
            }

        }
    }

}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
            .modelContainer(for:User.self, inMemory: true)
    }
}
