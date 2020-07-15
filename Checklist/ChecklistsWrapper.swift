//
//  ChecklistsWrapper.swift
//  Checklist
//
//  Created by Miguel Themann on 15.07.20.
//

import Foundation

class ChecklistsWrapper: NSObject, ObservableObject {
    
    @Published var checklists = [Checklist]()
    
    override init() {
        super.init()
        load()
    }
    
    deinit {
        save()
    }
    
    func load () {
        print("Loading…")
        if let myChecklists = try? JSONDecoder().decode([Checklist].self, from: UserDefaults().data(forKey: "checklists") ?? Data()) {
            checklists = myChecklists
        }
    }
    
    func save() {
        print("Saving…")
        if let data = try? JSONEncoder().encode(checklists) {
            UserDefaults().set(data, forKey: "checklists")
        }
    }
}
