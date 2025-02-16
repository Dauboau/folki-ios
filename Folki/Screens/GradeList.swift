//
//  GradeList.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 10/02/25.
//

import SwiftUI
import SwiftData

struct GradeList: View {
    
    let token : String? = UserDefaults.standard.string(forKey: "token")
    
    let userSubject : UserSubject
    
    @Environment(\.modelContext) var context
    @Query private var grades: [Grade]
    
    init(userSubject: UserSubject) {
        self.userSubject = userSubject
        
        let userSubjectId:Int = userSubject.id
        _grades = Query(filter: #Predicate { $0.userSubjectId == userSubjectId }, sort: \Grade.createdAt)
    }
    
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
                
                List{
                    
                    ForEach(grades) { grade in
                        
                        GradeListCard(grade)
                            .swipeActions(edge: .trailing,allowsFullSwipe: false){
                                Button("Excluir",systemImage: "minus.square.fill"){
                                    
                                    print("WIP - Deletar Nota")
                                    
                                    withAnimation(.snappy) {
                                        context.delete(grade)
                                    }
                                    
                                }
                                .tint(Color("Primary_Red"))
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
            
        }.onAppear {
            updateData()
        }
        
    }
    
    func updateData() {
        Task.detached(){
            
            // Get grades
            let gradesAux = await getGrades(token: token!, subjectId: userSubject.id)
            
            if(gradesAux == nil){
                return
            }
            
            await MainActor.run{
                
                #if DEBUG
                print(Default.separator)
                #endif
                
                // Inserting and Updating grades
                for gradeAux in gradesAux! {
                    
                    var gradeFound = false
                    for grade in grades {
                        if(grade == gradeAux){
                            #if DEBUG
                            print("\(grade.name) updated!")
                            #endif
                            gradeFound = true
                            grade.update(gradeAux)
                            break
                        }
                    }
                    
                    if(!gradeFound){
                        #if DEBUG
                        print("\(gradeAux.name) created!")
                        #endif
                        context.insert(gradeAux)
                    }
                    
                }
                
            }
            
        }
    }
    
}

#Preview {
    GradeList(userSubject:
        UserSubject(
            id: 39277,
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
    .modelContainer(for:Grade.self, inMemory: true)
}

struct GradeListCard: View {
    
    let grade: Grade
    
    init(_ grade: Grade) {
        self.grade = grade
    }
    
    var body: some View {
        
        HStack{
            Text("\(grade.name) (\(Int(grade.percentage))%)")
                .foregroundStyle(.white)
                .bold()
                .padding(.leading)
                .lineLimit(1)
            
            Spacer()
            
            Text("\(String(format: "%.1f", grade.value))")
                .foregroundStyle(.white)
                .bold()
                .padding(.trailing)
            
        }
        .padding(.vertical,CSS.textCardPadding)
        .background(Color("Gray_2"))
        .cornerRadius(CSS.cornerRadius)
        
    }
}
