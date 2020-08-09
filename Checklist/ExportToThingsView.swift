//
//  ExportToThingsView.swift
//  Checklist
//
//  Created by Miguel Themann on 17.07.20.
//

import SwiftUI

struct ExportToThingsView: View {
    
    @StateObject var wrapper: ChecklistsWrapper
    
    var body: some View {
            List(wrapper.checklists) { checklist in
                HStack {
                    Image(systemName: checklist.icon)
                    Text(checklist.name)
                }
                .onTapGesture {
                    exportToThings(checklist: checklist)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Export to Things")
    }
}

struct ExportToThingsView_Previews: PreviewProvider {
    static var previews: some View {
        ExportToThingsView(wrapper: ChecklistsWrapper())
    }
}
