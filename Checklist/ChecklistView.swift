//
//  ChecklistView.swift
//  Checklist
//
//  Created by Miguel Themann on 15.07.20.
//

import SwiftUI
import MobileCoreServices

struct ChecklistView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let delegate: ChecklistViewDelegate
    
    @State var checklist: Checklist
    
    @State private var showingEmptyItem = false
    
    @State private var newItemTitle = ""
    
    var body: some View {
        List {
            ForEach(checklist.items) { checklistItem in
                HStack {
                    CheckToggle(value: checklistItem.checked) { checked in
                            checklist.items[checklist.items.firstIndex(where: {$0.id == checklistItem.id})!].checked = checked
                            delegate.changeChecklist(checklist)
                    }
                    Text(checklistItem.title)
                        .foregroundColor(checklistItem.checked ? .secondary : .primary)
                }
            }
            .onInsert(of: [String(kUTTypeURL), String(kUTTypePlainText)], perform: insertItems)
            .onMove(perform: moveItems)
            .onDelete(perform: deleteItems)
            if showingEmptyItem {
                TextField("new item", text: $newItemTitle)
                Button(action: {
                    addItem()
                }) {
                    Text("Add")
                        .foregroundColor(newItemTitle.isEmpty ? .secondary : .blue)
                }
                .disabled(newItemTitle.isEmpty)
            }
        }
        .listStyle(SidebarListStyle())
        .animation(.easeInOut)
        .navigationTitle(checklist.name)
        .navigationBarItems(leading: EditButton(), trailing: Button(action: {
            showingEmptyItem = true
        }) {
            Image(systemName: "plus")
                .foregroundColor(colorScheme == .dark ? .white : .black)
        })
        .onAppear(perform: checkForEmptyList)
    }
    
    func toggleItem(id: UUID) {
        delegate.changeChecklist(checklist)
    }
    
    func addItem() {
        let item = ChecklistItem(title: newItemTitle)
        checklist.items.append(item)
        showingEmptyItem = false
        newItemTitle = ""
        delegate.changeChecklist(checklist)
    }
    
    func insertItems(at offset: Int, itemProvider: [NSItemProvider]) {
        var item: ChecklistItem
        var title: String? = nil
        for provider in itemProvider {
            if provider.canLoadObject(ofClass: URL.self) {
                _ = provider.loadObject(ofClass: URL.self) { url, error in
                    if let url = url {
                        title = url.absoluteString
                    }
                }
            } else if provider.canLoadObject(ofClass: String.self) {
                _ = provider.loadObject(ofClass: String.self) { string, error in
                    if let string = string {
                        title = string
                    }
                }
            }
            if let title = title {
                item = ChecklistItem(title: title)
                checklist.items.insert(item, at: offset)
                delegate.changeChecklist(checklist)
            }
            title = nil
        }
    }
    
    func checkForEmptyList() {
        if checklist.items.count == 0 {
            showingEmptyItem = true
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        checklist.items.remove(atOffsets: offsets)
        delegate.changeChecklist(checklist)
        checkForEmptyList()
    }
    
    func moveItems(source: IndexSet, destination: Int) {
        checklist.items.move(fromOffsets: source, toOffset: destination)
        delegate.changeChecklist(checklist)
    }
}

protocol ChecklistViewDelegate {
    func changeChecklist(_ checklist: Checklist)
}

struct ChecklistView_Previews: PreviewProvider, ChecklistViewDelegate {
    static var previews: some View {
        ChecklistView(delegate: self as! ChecklistViewDelegate, checklist: Checklist(icon: "plane", name: "My Checklist", items: [ChecklistItem(title: "Hello there (#1)"), ChecklistItem(title: "Hello hoo (#2)")]))
    }
    func changeChecklist(_ checklist: Checklist) {}
}
