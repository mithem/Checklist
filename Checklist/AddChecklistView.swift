//
//  AddChecklistView.swift
//  Checklist
//
//  Created by Miguel Themann on 15.07.20.
//

import SwiftUI

struct AddChecklistView: View {
    
    let delegate: AddChecklistViewDelegate
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name = "My Checklist"
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("name", text: $name)
                    VStack {
                        HStack {
                            AddChecklistViewIconSelector(icon: "checkmark", delegate: self)
                            AddChecklistViewIconSelector(icon: "paperplane", delegate: self)
                            AddChecklistViewIconSelector(icon: "airplane", delegate: self)
                            AddChecklistViewIconSelector(icon: "tram", delegate: self)
                        }
                    }
                }
            }
            .navigationTitle("New checklist")
        }
    }
    
    func addChecklist(icon: String) {
        let checklist = Checklist(icon: icon, name: name)
        delegate.add(checklist: checklist)
        presentationMode.wrappedValue.dismiss()
    }
}

extension AddChecklistView: AddChecklistViewIconSelectorDelegate {
    func selected(icon: String) {
        addChecklist(icon: icon)
    }
}

fileprivate struct AddChecklistViewIconSelector: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let icon: String
    let delegate: AddChecklistViewIconSelectorDelegate
    
    var body: some View {
        Image(systemName: icon)
            .padding(50)
            .frame(width: 50, height: 50)
            .background((colorScheme == .dark ? Color.white : Color.black).opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onTapGesture {
                delegate.selected(icon: icon)
            }
    }
}

fileprivate protocol AddChecklistViewIconSelectorDelegate {
    func selected(icon: String)
}

protocol AddChecklistViewDelegate {
    func add(checklist: Checklist)
}

struct AddChecklistView_Previews: PreviewProvider, AddChecklistViewDelegate {
    static var previews: some View {
        AddChecklistView(delegate: self as! AddChecklistViewDelegate)
    }
    func add(checklist: Checklist) {}
}
