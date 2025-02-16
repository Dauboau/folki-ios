//
//  AbsenceList.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 10/02/25.
//

import SwiftUI

struct AbsenceList: View {
    
    let token : String? = UserDefaults.standard.string(forKey: "token")
    
    let userSubject : UserSubject
    
    @State var absences : [Absence] = []
    
    var body: some View {
        ZStack {
            
            DefaultBackground()

            VStack {
                
                HStack{
                    Text("\(userSubject.absences!) Faltas")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.bottom,CSS.paddingBottomText)
                
                HStack{
                    Text("Suas Faltas em \(userSubject.subjectClass.subject.name)")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.bottom,CSS.paddingBottomText)
                
            }
            .safeAreaPadding()
            
        }.onAppear {
            updateData()
        }
        
    }
    
    func updateData() {
        Task.detached(){
            
            // Get grades
            let absencesAux = await getAbsences(token: token!, subjectId: userSubject.id!)
            
            await MainActor.run{
                absencesAux!.forEach {
                    absence in
                    absences.append(absence)
                }
            }
            
        }
    }
    
}

#Preview {
    AbsenceList(userSubject:
        UserSubject(
            id: 39274,
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
