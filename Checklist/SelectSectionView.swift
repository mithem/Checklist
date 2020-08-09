//
//  SelectSectionView.swift
//  Checklist
//
//  Created by Miguel Themann on 17.07.20.
//

import SwiftUI

struct SelectSectionView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    let sections: [Section]
    let delegate: SelectSectionViewDelegate
    
    var body: some View {
        NavigationView {
            List(sections) { section in
                Button(section.name) {
                    delegate.tapped(section: section)
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.primary)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select section")
        }
    }
}

protocol SelectSectionViewDelegate {
    func tapped(section: Section)
}

struct SelectSectionView_Previews: PreviewProvider, SelectSectionViewDelegate {
    func tapped(section: Section) {}
    static var previews: some View {
        SelectSectionView(sections: checklistForPreviews.sections, delegate: self as! SelectSectionViewDelegate)
    }
}
