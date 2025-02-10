//
//  Faltas.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 08/02/25.
//

import SwiftUI

struct Absences: View {
    
    let userSubjects : [UserSubject]
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                DefaultBackground()
                
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
                    
                    List{
                        
                        ForEach(userSubjects) { userSubject in
                            
                            AbsencesCard(userSubject:userSubject)
                            
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical, CSS.paddingVerticalList)
                        
                        .swipeActions(edge: .leading,allowsFullSwipe: true){
                            Button("Adicionar Falta",systemImage: "plus.square"){
                                print("WIP - Adicionar Falta")
                            }
                            .tint(Color("Gray_2"))
                        }
                                                
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
    Absences(userSubjects:
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

fileprivate struct AbsencesCard: View {
    
    let userSubject : UserSubject
    
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
