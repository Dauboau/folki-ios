//
//  Item.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 05/02/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
