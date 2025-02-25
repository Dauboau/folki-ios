//
//  Grade.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 09/02/25.
//

import SwiftUI

struct Grades: View {
    
    @State private var addGradeSubject: UserSubject?
    
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
                                        addGradeSubject = userSubject
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
                    
                    .sheet(item: $addGradeSubject){userSubject in
                        AddGradeSheet(userSubject: userSubject)
                    }
                    
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
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack {
                        Text(String("Total de \(userSubject.grading) de 10.0"))
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

fileprivate struct AddGradeSheet: View {
    
    let token : String? = UserDefaults.standard.string(forKey: "token")
    
    let userSubject : UserSubject
    
    @State private var activityName = ""
    @State private var finalGradePercentage = ""
    @State private var grade = ""
    @State private var errorFlag: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataValidity: Cache.Validity
    
    var body: some View {
        
        ZStack{
            
            DefaultBackground()
            
            VStack{
                
                Text("Adicionar Nota")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(CSS.paddingBottomText)
                
                TextField("Nome da Atividade (P1, P2, etc.)", text: $activityName)
                    .textFieldStyle(.roundedBorder)
                    .padding(CSS.paddingBottomText)
                
                TextField("Porcentagem na Nota Final (0 a 100)", text: $finalGradePercentage)
                    .textFieldStyle(.roundedBorder)
                    .padding(CSS.paddingBottomText)
                
                TextField("Nota da Atividade (0 a 10)", text: $grade)
                    .textFieldStyle(.roundedBorder)
                    .padding(CSS.paddingBottomText)
                
                HStack{
                    Button(action: {
                        
                        if(activityName.isEmpty || finalGradePercentage.isEmpty || grade.isEmpty){
                            errorFlag = true
                            return
                        }
                        
                        addData(userSubject, activityName, Float(finalGradePercentage) ?? 0, Float(grade) ?? 0)
                    }) {
                        Text("Adicionar")
                            .frame(maxWidth: CSS.maxWidth)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primaryPurple)
                    .controlSize(.regular)
                    .padding(.top,20)
                }
                
                .alert("Erro de Preenchimento", isPresented: $errorFlag, actions: {
                    Button("Tentar Novamente") {}
                }, message: {
                    Text("Por favor preencha todos os campos.")
                })
                
            }
            .safeAreaPadding()
            
        }
        
    }
    
    func addData(_ userSubject: UserSubject, _ name: String, _ finalGradePercentage: Float, _ grade: Float){
        Task.detached(){
            
            // Add Absence
            let addGradeAux = addGrade(token: token!,subjectId: userSubject.id,name: name,percentage: finalGradePercentage,value: grade)
            
            if(addGradeAux == nil){
                return
            }
            
            if(addGradeAux!){
                await MainActor.run{
                    #if DEBUG
                    print("\(userSubject.subjectClass.subject.name) grade added!")
                    #endif
                    
                    // Triggers Reload of Data
                    dataValidity.valid = false
                    
                    // Dismiss Sheet
                    dismiss()
                    
                }
            }
            
        }
    }
    
}
