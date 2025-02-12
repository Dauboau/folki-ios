//
//  Week.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 12/02/25.
//

import SwiftUI

struct Week: View {
    
    var body: some View {
        Text("Hello, World!")
    }
    
}

#Preview {
    Week()
}

struct WeekCard: View {
    
    let userSubject : UserSubject
    
    let nextLessonAvailableDay : AvailableDay?
    
    init(userSubject: UserSubject) {
        self.userSubject = userSubject
        nextLessonAvailableDay = userSubject.subjectClass.getNextAvailableDay()
    }
    
    var body: some View {
        ZStack {
            Color.primaryPurple
                .cornerRadius(CSS.cornerRadius)
            
            NavigationLink(destination:
                AbsenceList(userSubject:userSubject)
            ){
                VStack {
                    HStack {
                        Text("\(userSubject.subjectClass.subject.name)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    HStack {
                        Text("\(nextLessonAvailableDay?.start ?? "") - \(nextLessonAvailableDay?.end ?? "")")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    HStack {
                        Text(String("\(userSubject.absences!) Faltas Cadastradas"))
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                
            }
            .padding()
            .foregroundStyle(.white)
            
        }
    }
}
