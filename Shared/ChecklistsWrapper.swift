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
        
        let ud = UserDefaults()
        
        if let data = ud.data(forKey: "checklists") {
            if let myChecklists = try? JSONDecoder().decode([Checklist].self, from: data) {
                checklists = myChecklists
            }
        }
        
        if let data = ud.data(forKey: "gallery") {
            if let myGallery = try? JSONDecoder().decode([ChecklistBlueprint].self, from: data) {
                galleryChecklists = myGallery
            }
        }
    }
    
    func save() {
        
        let ud = UserDefaults()
        
        if let data = try? JSONEncoder().encode(checklists) {
            ud.set(data, forKey: "checklists")
        }
        if let data = try? JSONEncoder().encode(galleryChecklists) {
            ud.set(data, forKey: "gallery")
        }
    }
}
