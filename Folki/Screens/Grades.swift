//
//  Grade.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 09/02/25.
//

import SwiftUI

struct Grades: View {
    
    let userSubjects : [UserSubject]
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                DefaultBackground()
                
                VStack{
                    
                    HStack{
                        Text("Notas")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    HStack{
                        Text("Se preparando melhor :)")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    List{
                        
                        ForEach(userSubjects) { userSubject in
                            
                            GradeCard(userSubject:userSubject)
                                .swipeActions(edge: .leading,allowsFullSwipe: true){
                                    Button("Adicionar",systemImage: "plus.square"){
                                        print("WIP - Adicionar Nota")
                                    }
                                    .tint(Color("Gray_2"))
                                }
                            
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .padding(.vertical, CSS.paddingVerticalList)
                                                
                    }
                    .listStyle(.grouped)
                    .scrollContentBackground(.hidden)
                    .contentMargins(.vertical, 0)
                }
                .safeAreaPadding()
                
            }
            
        }
    }
}

#Preview {
    Grades(userSubjects:
        [
            UserSubject(
                id: 39275,
                absences: 0,
                grading: 3.5,
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
                grading: 7.2,
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
                grading: 0,
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

fileprivate struct GradeCard: View {
    
    let userSubject : UserSubject

    var body: some View {
        
        ZStack {
            
            switch(userSubject.grading){
                case let grade where grade >= 5:
                    Color.primaryGreen
                        .cornerRadius(CSS.cornerRadius)
                case let grade where grade < 5:
                    Color.primaryRed
                        .cornerRadius(CSS.cornerRadius)
                default:
                    Color.primaryPurple
                        .cornerRadius(CSS.cornerRadius)
            }

            NavigationLink(destination:
                GradeList(userSubject:userSubject)
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
                        Text(String("Total de \(userSubject.grading) de 10.0"))
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
