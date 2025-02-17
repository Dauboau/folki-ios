//
//  ActivityList.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 14/02/25.
//

import SwiftUI

struct ActivityList: View {
    
    let activity : Activity
    
    let backgroundDefault: Bool
    
    init(activity: Activity,backgroundDefault: Bool = true) {
        self.activity = activity
        self.backgroundDefault = backgroundDefault
    }
    
    var body: some View {
        ZStack {
            
            DefaultBackground()
            
            if(!backgroundDefault){
                if(UIDevice.current.userInterfaceIdiom == .phone){
                    activity.getColor()
                }else{
                    activity.getColor()
                        .ignoresSafeArea()
                }
            }

            VStack {
                
                Text("\(activity.getType())")
                    .foregroundStyle(.white)
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Text("\(activity.name)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom,CSS.paddingBottomText)
                    .multilineTextAlignment(.center)
                
                Text("\(activity.subjectClass?.subject.name ?? "") - \(String(format: "%.1f", activity.value)) Pontos")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Text("\(activity.getDeadlineDate()?.formatted(date: .complete, time: .omitted) ?? "")")
                    .foregroundColor(.white)
                
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
        ),
        backgroundDefault:false
    )
}
