//
//  Home.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 07/02/25.
//

import SwiftUI

struct Home: View {
    
    @State var user : User?
    
    var body: some View {
        
        Text("Hello, \(user?.name ?? "Usuário")!")
        
    }
}

#Preview {
    Home(user: User(id: 6681, email: "romanzinidaniel@usp.br", name: "Daniel", instituteId: 32, courseId: 84, isVerified: nil, institute: nil, notificationId: nil, userVersion: nil, university: nil))
}
