//
//  ChecklistListView.swift
//  Checklist
//
//  Created by Miguel Themann on 15.07.20.
//

import SwiftUI

extension AnyTransition {
    static var getAttention: AnyTransition {
        return AnyTransition.scale(scale: 1.25)
    }
}

struct ChecklistListView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject private var wrapper = ChecklistsWrapper()
    
    @State private var showingAddChecklistView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(wrapper.checklists) { checklist in
                    NavigationLink(destination: ChecklistView(delegate: self, checklist: checklist)) {
                        HStack {
                            Image(systemName: checklist.icon)
                                .frame(width: 30, height: 30)
                            Text(checklist.name)
                        }
                    }
                }
                .onDelete(perform: deleteChecklists)
            }
            .animation(.easeInOut)
            .navigationTitle("My checklists")
            .navigationBarItems(trailing: Button(action: {
                showingAddChecklistView = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            })
        }
        .onDisappear {
            wrapper.save()
        }
        .sheet(isPresented: $showingAddChecklistView) {
            AddChecklistView(delegate: self)
        }
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
