//
//  ChecklistListView.swift
//  Checklist
//
//  Created by Miguel Themann on 15.07.20.
//

import SwiftUI

struct ChecklistListView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.editMode) private var editMode
    
    @StateObject private var wrapper = ChecklistsWrapper()
    
    @State private var showingAddChecklistView = false
    @State private var showingAddedToGalleryActionSheet = false
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: GalleryView(wrapper: wrapper)) {
                    HStack {
                        Image(systemName: "rectangle.grid.3x2.fill")
                            .frame(width: 30, height: 30)
                        Text("Gallery")
                    }
                }
                NavigationLink(destination: SettingsView(wrapper: wrapper)) {
                    HStack {
                        Image(systemName: "gearshape.2")
                            .frame(width: 30, height: 30)
                        Text("Settings")
                    }
                }
                ForEach(wrapper.checklists) { checklist in
                    NavigationLink(destination: ChecklistView(delegate: self, checklist: checklist)) {
                        HStack {
                            Image(systemName: "plus")
                                .onTapGesture {
                                    addToGallery(checklist: checklist)
                                }
                            Image(systemName: checklist.icon)
                                .frame(width: 30, height: 30)
                            Text(checklist.name)
                        }
                    }
                }
                .onMove(perform: moveChecklists)
                .onDelete(perform: deleteChecklists)
            }
            .animation(.easeInOut)
            .listStyle(SidebarListStyle())
            .navigationTitle("My checklists")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                showingAddChecklistView = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding()
            })
            .actionSheet(isPresented: $showingAddedToGalleryActionSheet) {
                ActionSheet(title: Text("Added to gallery"), message: Text("Successfully added checklist as a template to the gallery"), buttons: [.default(Text("OK"))])
            }
        }
        .onDisappear {
            wrapper.save()
        }
        .sheet(isPresented: $showingAddChecklistView) {
            AddChecklistView(delegate: self)
        }
    }
    
    func addToGallery(checklist: Checklist) {
        let blueprint = getBlueprint(from: checklist)
        wrapper.galleryChecklists.append(blueprint)
        changeChecklist(checklist)
        showingAddedToGalleryActionSheet = true
    }
    
    func moveChecklists(offsets: IndexSet, destination: Int) {
        wrapper.checklists.move(fromOffsets: offsets, toOffset: destination)
        wrapper.save()
    }
    
    func deleteChecklists(offsets: IndexSet) {
        wrapper.checklists.remove(atOffsets: offsets)
        wrapper.save()
    }
}

extension ChecklistListView: ChecklistViewDelegate {
    func changeChecklist(_ checklist: Checklist) {
        wrapper.checklists[wrapper.checklists.firstIndex(where: {$0.id == checklist.id})!] = checklist
        wrapper.save()
    }
}

extension ChecklistListView: AddChecklistViewDelegate {
    func add(checklist: Checklist) {
        wrapper.checklists.append(checklist)
        wrapper.save()
    }
}

struct ChecklistListView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistListView()
    }
}
