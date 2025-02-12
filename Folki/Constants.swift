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

