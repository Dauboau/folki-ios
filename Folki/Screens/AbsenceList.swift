//
//  AbsenceList.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 10/02/25.
//

import SwiftUI
import SwiftData

struct AbsenceList: View {
    
    let token : String? = UserDefaults.standard.string(forKey: "token")
    
    let userSubject : UserSubject
    
    @Environment(\.modelContext) var context
    @Query private var absences: [Absence]
    
    var body: some View {
        ZStack {
            
            DefaultBackground()

            VStack {
                
                HStack{
                    Text("\(userSubject.absences) Faltas")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .contentTransition(.numericText())
                    Spacer()
                }
                .padding(.bottom,CSS.paddingBottomText)
                
                HStack{
                    Text("Suas Faltas em \(userSubject.subjectClass.subject.name)")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.bottom,CSS.paddingBottomText)
                
                List{
                    
                    ForEach(absences) { absence in
                        
                        AbsenceListCard(absence)
                            .swipeActions(edge: .trailing,allowsFullSwipe: false){
                                Button("Excluir",systemImage: "minus.square.fill"){
                                    
                                    withAnimation(.snappy) {
                                        deleteData(absence)
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
    
    func deleteData(_ absence: Absence){
        Task.detached(){
            
            // Delete absence
            let succesfulAux = deleteAbsence(token: token!,absence: absence)
            
            if(succesfulAux == nil){
                return
            }
            
            if(succesfulAux!){
                await MainActor.run{
                    
                    #if DEBUG
                    print("\(absence.date) deleted!")
                    #endif
                    
                    context.delete(absence)
                    withAnimation {
                        userSubject.absences = userSubject.absences - 1
                    }
                    
                }
            }
        
        }
    }
    
    func updateData() {
        Task.detached(){
            
            // Get absences
            let absencesAux = await getAbsences(token: token!, subjectId: userSubject.id)
            
            if(absencesAux == nil){
                return
            }
            
            await MainActor.run{
                
            #if DEBUG
            print(Default.separator)
            #endif

            // Inserting and Updating absences
            for absenceAux in absencesAux! {
                
                var absenceFound = false
                for absence in absences {
                    if(absence == absenceAux){
                        #if DEBUG
                        print("\(absence.date) updated!")
                        #endif
                        absenceFound = true
                        absence.update(absenceAux)
                        break
                    }
                }
                
                if(!absenceFound){
                    #if DEBUG
                    print("\(absenceAux.date) created!")
                    #endif
                    context.insert(absenceAux)
                }
                
            }

            // Deleting absences
            for absence in absences {
                if(!absencesAux!.contains(where: { $0 == absence })){
                    #if DEBUG
                    print("\(absence.date) deleted!")
                    #endif
                    context.delete(absence)
                }
            }

            // Save to persist the user data
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }

            #if DEBUG
            print(Default.separator)
            #endif
                
            }
            
        }
    }
    
}

#Preview {
    AbsenceList(userSubject:
        UserSubject(
            id: 39274,
            absences: 2,
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
    .modelContainer(for:Absence.self, inMemory: true)
}

struct AbsenceListCard: View {
    
    let absence: Absence
    
    init(_ absence: Absence) {
        self.absence = absence
    }
    
    var body: some View {
        
        HStack{
            Text("\(absence.getDate()!.formatted(date: .abbreviated, time: .omitted))")
                .foregroundStyle(.white)
                .bold()
                .padding(.leading)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical,CSS.textCardPadding)
        .background(Color("Gray_2"))
        .cornerRadius(CSS.cornerRadius)
        
    }
}
