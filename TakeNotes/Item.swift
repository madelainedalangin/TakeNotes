//
//  Item.swift
//  TakeNotes
//
//  Created by Madelaine Dalangin on 2026-01-02.
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
