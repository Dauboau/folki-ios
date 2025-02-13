//
//  Calendar.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 12/02/25.
//

import SwiftUI

struct CalendarScreen: View {
    
    let activities : [Activity]
    
    var body: some View {
        
        Text("Hello, World!")
        
    }
}

#Preview {
    CalendarScreen(activities: [
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
    ])
}
