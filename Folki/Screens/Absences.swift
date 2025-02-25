//
//  Faltas.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 08/02/25.
//

import SwiftUI

struct Absences: View {
    
    @State private var addAbsenceSubject: UserSubject?
    
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
                                .swipeActions(edge: .leading,allowsFullSwipe: true){
                                    Button("Adicionar Falta",systemImage: "plus.square"){               
                                        addAbsenceSubject = userSubject
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
                    
                    .sheet(item: $addAbsenceSubject){userSubject in
                        AddAbsenceSheet(userSubject: userSubject)
                    }
                    
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
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack {
                        Text(String("\(userSubject.absences) Faltas Cadastradas"))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                
            }
            .padding()
            .foregroundStyle(.white)
            
        }
    }
}

fileprivate struct AddAbsenceSheet: View {
    
    let token : String? = UserDefaults.standard.string(forKey: "token")
    
    let userSubject : UserSubject
    
    @State private var date = Date()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack{
            
            DefaultBackground()
            
            VStack{
                
                Text("Adicionar Falta")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(CSS.paddingBottomText)
                
                DatePicker("Data da Falta", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .foregroundColor(.white)
                    .environment(\.colorScheme, .dark)
                
                HStack{
                    Button(action: {
                        addData(userSubject,date)
                    }) {
                        Text("Adicionar")
                            .frame(maxWidth: CSS.maxWidth)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primaryPurple)
                    .controlSize(.regular)
                    .padding(.top,20)
                }
            }
            .safeAreaPadding()
            
        }
        
    }
    
    func addData(_ userSubject: UserSubject, _ date: Date){
        Task.detached(){
            
            // Add Absence
            let addAbsenceAux = addAbsence(token: token!,subjectId: userSubject.id,date: date)
            
            if(addAbsenceAux == nil){
                return
            }
            
            if(addAbsenceAux!){
                await MainActor.run{
                    #if DEBUG
                    print("\(userSubject.subjectClass.subject.name) absence added!")
                    #endif
                    
                    // Dismiss Sheet
                    dismiss()
                    
                }
            }
            
        }
    }
    
}
