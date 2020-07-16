//
//  ChecklistsWrapper.swift
//  Checklist
//
//  Created by Miguel Themann on 15.07.20.
//

import Foundation

class ChecklistsWrapper: NSObject, ObservableObject {
    
    @Published var checklists = [Checklist]()
    @Published var galleryChecklists = [ChecklistBlueprint]()
    
    override init() {
        super.init()
        load()
    }
    
    deinit {
        save()
    }
    
    func load () {
        if let myChecklists = try? JSONDecoder().decode([Checklist].self, from: UserDefaults().data(forKey: "checklists") ?? Data()) {
            checklists = myChecklists
        }
        if let myGallery = try? JSONDecoder().decode([ChecklistBlueprint].self, from: UserDefaults().data(forKey: "gallery") ?? Data()) {
            galleryChecklists = myGallery
        }
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(checklists) {
            UserDefaults().set(data, forKey: "checklists")
        }
        if let data = try? JSONEncoder().encode(galleryChecklists) {
            UserDefaults().set(data, forKey: "gallery")
        }
    }
}
