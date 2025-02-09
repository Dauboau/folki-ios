//
//  Faltas.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 08/02/25.
//

import SwiftUI

struct Faltas: View {
    
    let userSubjects : [UserSubject]
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                Color.gray2
                    .ignoresSafeArea()
                
                VStack{
                    
                    HStack{
                        Text("Faltas")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    HStack{
                        Text("Ainda posso faltar?")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    ScrollView{
                        
                        ForEach(userSubjects) { userSubject in
                            
                            FaltasCard(subjectName: userSubject.subjectClass.subject.name, nFaltas: userSubject.absences!)
                            
                        }
                        
                    }
                    
                }
                .safeAreaPadding()
                
            }
            
        }
        
    }
}

#Preview {
    Faltas(userSubjects:
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

fileprivate struct FaltasCard: View {
    
    let subjectName: String
    let nFaltas: Int

    var body: some View {
        ZStack {
            Color.primaryPurple
                .cornerRadius(CSS.cornerRadius)

            VStack {
                HStack {
                    Text("\(subjectName)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                HStack {
                    Text(String("\(nFaltas) Faltas Cadastradas"))
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding()
        }
        .padding(.bottom, CSS.paddingBottomText)
    }
}
