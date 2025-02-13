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

import SwiftUI

extension Color {
    init(hex: String, opacity: Double = 1) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: opacity
        )
    }
}
