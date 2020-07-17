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
    @State private var showingItemVsSectionSelectActionSheet = false
    @State private var showingAddSectionView = false
    
    @State private var newItemTitle = ""
    @State private var newSectionTitle = ""
    
    var body: some View {
        List {
            ForEach(checklist.sections) { section in
                SwiftUI.Section(header: Text(section.name).textCase(.none)) {
                    ForEach(section.items) { checklistItem in
                        HStack {
                            CheckToggle(value: checklistItem.checked) { checked in
                                section.items[section.items.firstIndex(where: {$0.id == checklistItem.id})!].checked = checked
                                delegate.changeChecklist(checklist)
                            }
                            Text(checklistItem.title)
                                .foregroundColor(checklistItem.checked ? .secondary : .primary)
                        }
                    }
                    .onMove(perform: moveItems)
                    .onDelete(perform: deleteItems)
                }
            }
            SwiftUI.Section {
                if showingEmptyItem {
                    TextField("new item", text: $newItemTitle)
                    Group {
                        if checklist.sections.count > 1 {
                            NavigationLink(destination: SelectSectionView(sections: checklist.sections, delegate: self)) {
                                Text("Add")
                                    .foregroundColor(newItemTitle.isEmpty ? .secondary : .blue)
                            }
                            .disabled(newItemTitle.isEmpty)
                        } else if checklist.sections.count == 1 {
                            Button(action: {
                                addItem(to: checklist.sections.first!)
                            }) {
                                Text("Add")
                                    .foregroundColor(newItemTitle.isEmpty ? .secondary : .blue)
                            }
                        }
                    }
                } else if showingAddSectionView {
                    TextField("section name", text: $newSectionTitle)
                    Button(action: {
                        addSection()
                    }) {
                        Text("Add")
                            .foregroundColor(newSectionTitle.isEmpty ? .secondary : .blue)
                    }
                    .disabled(newSectionTitle.isEmpty)
                }
            }
            SwiftUI.Section {
                NavigationLink(destination: SectionListView(sections: checklist.sections, delegate: self)) {
                    Text("Manage sections")
                }
            }
        }
        .listStyle(SidebarListStyle())
        .animation(.easeInOut)
        .navigationTitle(checklist.name)
        .navigationBarItems(leading: EditButton(), trailing: Button(action: {
            showingItemVsSectionSelectActionSheet = true
        }) {
            Image(systemName: "plus")
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding()
        })
        .onAppear(perform: checkForEmptyList)
        .actionSheet(isPresented: $showingItemVsSectionSelectActionSheet) {
            ActionSheet(title: Text("Add menu"), message: Text("Which one do you want to add to your checklist?"), buttons: [.default(Text("Item")) {showingEmptyItem = true}, .default(Text("Section")) {showingAddSectionView = true}, .cancel()])
        }
    }
    
    func toggleItem(id: UUID) {
        delegate.changeChecklist(checklist)
    }
    
    func addItem(to section: Section) {
        let item = ChecklistItem(title: newItemTitle)
        if let section = checklist.sections.first(where: {$0.id == section.id}) {
            section.items.append(item)
        } else {
            checklist.sections.append(Section(name: "My Section", items: [ChecklistItem(title: newItemTitle)]))
        }
        showingEmptyItem = false
        newItemTitle = ""
        delegate.changeChecklist(checklist)
    }
    
    func addSection() {
        let section = Section(name: newSectionTitle)
        checklist.sections.append(section)
        showingAddSectionView = false
        newSectionTitle = ""
        delegate.changeChecklist(checklist)
    }
    
    func checkForEmptyList() {
        if checklist.sections.count == 0{
            showingAddSectionView = true
        } else if checklist.sections.first!.items.count == 0{
            showingEmptyItem = true
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        checklist.sections.first?.items.remove(atOffsets: offsets)
        delegate.changeChecklist(checklist)
        checkForEmptyList()
    }
    
    func moveItems(source: IndexSet, destination: Int) {
        checklist.sections.first?.items.move(fromOffsets: source, toOffset: destination)
        delegate.changeChecklist(checklist)
    }
}

extension ChecklistView: SelectSectionViewDelegate {
    func tapped(section: Section) {
        addItem(to: section)
    }
}

extension ChecklistView: SectionListViewDelegate {
    func apply(sections: [Section]) {
        checklist.sections = sections
        delegate.changeChecklist(checklist)
    }
}

protocol ChecklistViewDelegate {
    func changeChecklist(_ checklist: Checklist)
}

struct ChecklistView_Previews: PreviewProvider, ChecklistViewDelegate {
    static var previews: some View {
        ChecklistView(delegate: self as! ChecklistViewDelegate, checklist: checklistForPreviews)
    }
    func changeChecklist(_ checklist: Checklist) {}
}
