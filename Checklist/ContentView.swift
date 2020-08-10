//
//  ContentView.swift
//  Checklist
//
//  Created by Miguel Themann on 15.07.20.
//

import SwiftUI

struct ContentView: View {
    
    let wrapper: ChecklistsWrapper
    
    let smallScreen: Bool
    
    var body: some View {
        Group {
            if let id = UserDefaults().object(forKey: "activeChecklist") as? String {
                if let checklist = wrapper.checklists.first(where: {$0.id.uuidString == id}) {
                    ChecklistListView(checklistToShow: checklist.id)
                } else {
                    ChecklistListView()
                }
            } else {
                if smallScreen {
                    ChecklistListView()
                } else {
                    ChecklistListView(checklistToShow: wrapper.checklists.first?.id)
                }
            }
        }
    }
    
    init() {
        wrapper = ChecklistsWrapper()
        let deviceInfo = UIDevice.current.modelName
        smallScreen = deviceInfo.starts(with: "iPhone") || deviceInfo.starts(with: "iPod")
    }
}

extension ContentView: ChecklistViewDelegate {
    func changeChecklist(_ checklist: Checklist) {
        wrapper.checklists[wrapper.checklists.firstIndex(where: {$0.id == checklist.id})!] = checklist
        wrapper.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
