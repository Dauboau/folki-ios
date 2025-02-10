//
//  Hub.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 08/02/25.
//

import SwiftUI
import SwiftData

/**
 Hub is an intermediate view that defines if the user is going to the NavigationView (logged in) or the Starter view(logged out) when opening the app
 */
struct Hub: View {
    
    @State var token : String? = UserDefaults.standard.string(forKey: "token")
    
    @Environment(\.modelContext) var context
    @Query() private var users: [User]
    var user: User? { users.first }

    var body: some View {
        
        if(user != nil){
            NavigationView()
        }else{
            Starter()
        }
        
    }
}

#Preview {
    Hub()
        .modelContainer(for:User.self, inMemory: true)
}
