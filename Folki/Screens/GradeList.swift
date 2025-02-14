//
//  GradeList.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 10/02/25.
//

import SwiftUI

struct GradeList: View {
    
    let userSubject : UserSubject
    
    var body: some View {
        ZStack {
            
            DefaultBackground()

            VStack {
                
                HStack{
                    Text("Notas!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.bottom,CSS.paddingBottomText)
                
                HStack{
                    Text("Suas Notas em \(userSubject.subjectClass.subject.name)")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.bottom,CSS.paddingBottomText)
                
            }
            .safeAreaPadding()
            
        }
        
    }
    
}

#Preview {
    GradeList(userSubject:
        UserSubject(
            id: 39275,
            absences: 0,
            grading: 4.2,
            subjectClass: SubjectClass(
                id: 21074,
                availableDays: [
                    AvailableDay(day: "qua", start: "14:00", end: "17:00")
                ],
                subject: Subject(
                    id: 15461,
                    name: "Multimídia",
                    code: "SCC0261",
                    driveItemsNumber: 0
                )
            )
        )
    )
}
