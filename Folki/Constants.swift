//
//  Constant.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 07/02/25.
//

import Foundation
import SwiftUI

struct CSS {
    
    static let maxWidth:CGFloat = 500
    static let paddingBottomText:CGFloat = 5
    static let paddingVerticalList:CGFloat = 5
    static let paddingVerticalScrollView:CGFloat = 2.5
    static let cornerRadius:CGFloat = 10
    
}

struct Default {
    
    static let user:User = User(id: 0, email: "estudante@gmail.com", name: "Estudante")
    
}

struct DefaultBackground: View {
    
    static let color = "Gray_1"
    
    var body: some View {
        Color(DefaultBackground.color)
            .ignoresSafeArea()
    }
}

extension Date {
    
    /**
     The weekday units are the numbers 1 through N (where for the Gregorian calendar N=7 and 1 is Sunday).
     */
    func getNextWeekday(_ targetWeekday: Int) -> Date {
        let calendar = Calendar.current
        let currentWeekday = calendar.component(.weekday, from: self)
        
        // Calculate the difference between current weekday and target weekday
        let daysToAdd = (targetWeekday - currentWeekday + 7) % 7
        let nextDate = calendar.date(byAdding: .day, value: daysToAdd, to: self) ?? self
        return nextDate
    }
}
