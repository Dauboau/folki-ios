//
//  File.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 07/02/25.
//

import Foundation
import SwiftData

@Model
final class Welcome {
    
    var firstTime: Bool
    
    init(firstTime: Bool) {
        self.firstTime = firstTime
    }
    
}
