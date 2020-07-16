//
//  models.swift
//  Checklist
//
//  Created by Miguel Themann on 15.07.20.
//

import Foundation

class ChecklistItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var checked: Bool
    
    init(title: String, checked: Bool = false) {
        id = UUID()
        self.title = title
        self.checked = checked
    }
}

class Checklist: Identifiable, Codable {
    let id: UUID
    var icon: String
    var name: String
    var items = [ChecklistItem]()
    
    init(icon: String, name: String, items: [ChecklistItem] = []) {
        id = UUID()
        self.icon = icon
        self.name = name
        self.items = items
    }
}

struct ChecklistBlueprint: Identifiable, Codable {
    let id: UUID
    var icon: String
    var name: String
    var items: [ChecklistBlueprintItem]
    
    init(icon: String, name: String, items: [ChecklistBlueprintItem]) {
        id = UUID()
        self.icon = icon
        self.name = name
        self.items = items
    }
}

struct ChecklistBlueprintItem: Identifiable, Codable {
    let id: UUID
    var title: String
    
    init(title: String) {
        id = UUID()
        self.title = title
    }
}
