//
//  Teste.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 10/02/25.
//

import SwiftUI

struct ScheduleHub: View {

    let userSubjects : [UserSubject]

    @State private var selectedSegment: String = "Week" // Default
    
    var body: some View {
        NavigationStack {
            ZStack{
                
                DefaultBackground()
                
                VStack {
                    
                    if selectedSegment == "Week" {
                        Absences(userSubjects:userSubjects)
                    } else {
                        Grade(userSubjects:userSubjects)
                    }
                    
                    Picker("Select View", selection: $selectedSegment) {
                        Text("Semana").tag("Week")
                        Text("Calendário").tag("Calendar")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .frame(maxWidth:CSS.maxWidth)
                    
                }
            }
        }
    }
}

#Preview {
    ScheduleHub(userSubjects:
        [
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
            ),
            UserSubject(
                id: 392753,
                absences: 1,
                grading: 4.2,
                subjectClass: SubjectClass(
                    id: 21074,
                    availableDays: [
                        AvailableDay(day: "qua", start: "14:00", end: "17:00")
                    ],
                    subject: Subject(
                        id: 15461,
                        name: "Processamento de Linguagem Natural",
                        code: "SCC0261",
                        driveItemsNumber: 0
                    )
                )
            ),
            UserSubject(
                id: 391275,
                absences: 4,
                grading: 4.2,
                subjectClass: SubjectClass(
                    id: 21074,
                    availableDays: [
                        AvailableDay(day: "qua", start: "14:00", end: "17:00")
                    ],
                    subject: Subject(
                        id: 15461,
                        name: "Teste e Inspeção de Software",
                        code: "SCC0261",
                        driveItemsNumber: 0
                    )
                )
            )
        ]
    )
}
