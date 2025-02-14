//
//  ActivityList.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 14/02/25.
//

import SwiftUI

struct ActivityList: View {
    
    let activity : Activity
    
    var body: some View {
        ZStack {
            
            DefaultBackground()

            VStack {
                
                HStack{
                    Text("\(activity.name)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.bottom,CSS.paddingBottomText)
                
                HStack{
                    Text("\(activity.subjectClass?.subject.name ?? "")")
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
    ActivityList(activity:
        Activity(id: 7757, name: "Lição de Multimídia", activityDescription: "", value: 3, subjectClassId: 21074, finishDate: "2025-02-12T15:00:00.000Z", type: "ACTIVITY",
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
             ),
         checked:false
        )
    )
}
