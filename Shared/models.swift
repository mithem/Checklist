//
//  models.swift
//  Checklist
//
//  Created by Miguel Themann on 15.07.20.
//

import Foundation

class ChecklistItem: Identifiable, Codable, Equatable {
    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        let c1 = lhs.title == rhs.title
        let c2 = lhs.checked == rhs.checked
        return c1 && c2
    }
    
    let id: UUID
    var title: String
    var checked: Bool
    
    init(title: String, checked: Bool = false) {
        id = UUID()
        self.title = title
        self.checked = checked
    }
}

class Checklist: Identifiable, Codable, Equatable {
    static func == (lhs: Checklist, rhs: Checklist) -> Bool {
        for section in lhs.sections {
            if !rhs.sections.contains(section) {
                return false
            }
        }
        let c1 = lhs.name == rhs.name
        let c2 = lhs.icon == rhs.icon
        return c1 && c2
    }
    
    let id: UUID
    var icon: String
    var name: String
    var sections = [Section]()
    
    init(icon: String, name: String, sections: [Section] = []) {
        id = UUID()
        self.icon = icon
        self.name = name
        self.sections = sections
    }
}

class Section: Identifiable, Codable, Equatable {
    static func == (lhs: Section, rhs: Section) -> Bool {
        for item in lhs.items {
            if !rhs.items.contains(item) {
                return false
            }
        }
        return lhs.name == rhs.name
    }
    
    let id: UUID
    var name: String
    var items: [ChecklistItem]
    
    init(name: String, items: [ChecklistItem] = []) {
        id = UUID()
        self.name = name
        self.items = items
    }
}

//MARK: Blueprints

struct SectionBlueprint: Identifiable, Codable {
    let id: UUID
    var name: String
    var items: [ChecklistBlueprintItem]
    
    init(name: String, items: [ChecklistBlueprintItem] = []) {
        id = UUID()
        self.name = name
        self.items = items
    }
}

struct ChecklistBlueprint: Identifiable, Codable {
    let id: UUID
    var icon: String
    var name: String
    var sections: [SectionBlueprint]
    
    init(icon: String, name: String, sections: [SectionBlueprint]) {
        id = UUID()
        self.icon = icon
        self.name = name
        self.sections = sections
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
