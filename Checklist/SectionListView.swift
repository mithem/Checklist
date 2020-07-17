//
//  SectionList.swift
//  Checklist
//
//  Created by Miguel Themann on 17.07.20.
//

import SwiftUI

struct SectionListView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State var sections: [Section]
    let delegate: SectionListViewDelegate
    
    var body: some View {
        List {
            ForEach(sections) { section in
                Text(section.name)
            }
            .onMove(perform: moveSections)
            .onDelete(perform: deleteSections)
        }
        .listStyle(SidebarListStyle())
        .onDisappear {
            delegate.apply(sections: sections)
        }
        .navigationTitle("Manage sections")
        .navigationBarItems(trailing: EditButton())
    }
    
    func moveSections(source: IndexSet, destination: Int) {
        sections.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteSections(offsets: IndexSet) {
        sections.remove(atOffsets: offsets)
    }
}

protocol SectionListViewDelegate {
    func apply(sections: [Section])
}

struct SectionList_Previews: PreviewProvider, SectionListViewDelegate {
    func apply(sections: [Section]) {}
    static var previews: some View {
        SectionListView(sections: checklistForPreviews.sections, delegate: self as! SectionListViewDelegate)
    }
}
