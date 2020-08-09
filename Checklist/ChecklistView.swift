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
    @State private var showingAddSectionView = false
    @State private var showingSelectSectionView = false
    
    @State private var showingSectionHasItemsWhenDeletingActionSheet = false
    @State private var showingItemVsSectionSelectActionSheet = false
    
    @State private var newItemTitle = ""
    @State private var newSectionTitle = ""
    
    @State private var sectionOffsetToDelete = IndexSet()
    
    var body: some View {
        List {
            ForEach(0..<1) { _ in
                if showingEmptyItem {
                    TextField("new item", text: $newItemTitle)
                    Group {
                        if checklist.sections.count > 1 {
                            Button(action: {
                                showingSelectSectionView = true
                            }) {
                                HStack {
                                    Text("Add")
                                        .foregroundColor(newItemTitle.isEmpty ? .secondary : .blue)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(newItemTitle.isEmpty ? .secondary : .black)
                                }
                            }
                            .disabled(newItemTitle.isEmpty)
                        } else if checklist.sections.count == 1 {
                            Button(action: {
                                addItem(to: checklist.sections.first!)
                            }) {
                                Text("Add")
                                    .foregroundColor(newItemTitle.isEmpty ? .secondary : .blue)
                            }
                            .disabled(newItemTitle.isEmpty)
                        }
                    }
                    .sheet(isPresented: $showingSelectSectionView) {
                        SelectSectionView(sections: checklist.sections, delegate: self)
                    }
                }
            }
            .onDelete { _ in
                showingEmptyItem = false
            }
            ForEach(0..<1) { _ in
                if showingAddSectionView {
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
            .onDelete { _ in
                showingAddSectionView = false
            }
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
                    .onMove { source, destination in
                        moveItems(source: source, destination: destination, in: section)
                    }
                    .onDelete { offsets in
                        deleteItems(offsets: offsets, of: section)
                    }
                }
            }
            .onDelete { offsets in
                sectionOffsetToDelete = offsets
                if checklist.sections[offsets[offsets.startIndex]].items.count == 0 {
                    deleteSection()
                } else {
                    showingSectionHasItemsWhenDeletingActionSheet = true
                }
            }
            NavigationLink(destination: SectionListView(sections: checklist.sections, delegate: self)) {
                Text("Manage sections")
            }
            .actionSheet(isPresented: $showingSectionHasItemsWhenDeletingActionSheet) {
                ActionSheet(title: Text("Section has items"), message: Text("All items in the section will be deleted permanently."), buttons: [.cancel(), .destructive(Text("Delete")) {deleteSection()}])
            }
        }
        .listStyle(SidebarListStyle()) // InsetGroupedListStyle doesn't give ability to collapse sections?!
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
    
    func deleteSection() {
        checklist.sections.remove(atOffsets: sectionOffsetToDelete)
        delegate.changeChecklist(checklist)
        checkForEmptyList()
    }
    
    func deleteItems(offsets: IndexSet, of section: Section) {
        section.items.remove(atOffsets: offsets)
        delegate.changeChecklist(checklist)
        checkForEmptyList()
    }
    
    func moveItems(source: IndexSet, destination: Int, in section: Section) {
        section.items.move(fromOffsets: source, toOffset: destination)
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
