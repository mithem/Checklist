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
                TextField("name", text: $name)
                VStack(alignment: .leading, spacing: 30) {
                    ScrollView(.horizontal) {
                        HStack {
                            AddChecklistViewIconSelector(icon: "checkmark", delegate: self)
                            AddChecklistViewIconSelector(icon: "paperplane", delegate: self)
                            AddChecklistViewIconSelector(icon: "airplane", delegate: self)
                            AddChecklistViewIconSelector(icon: "tram", delegate: self)
                            AddChecklistViewIconSelector(icon: "bus", delegate: self)
                            AddChecklistViewIconSelector(icon: "car", delegate: self)
                            AddChecklistViewIconSelector(icon: "bicycle", delegate: self)
                        }
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            AddChecklistViewIconSelector(icon: "cart", delegate: self)
                            AddChecklistViewIconSelector(icon: "house", delegate: self)
                            AddChecklistViewIconSelector(icon: "ticket", delegate: self)
                            AddChecklistViewIconSelector(icon: "heart", delegate: self)
                            AddChecklistViewIconSelector(icon: "gift", delegate: self)
                        }
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            AddChecklistViewIconSelector(icon: "graduationcap", delegate: self)
                            AddChecklistViewIconSelector(icon: "paperclip", delegate: self)
                            AddChecklistViewIconSelector(icon: "envelope", delegate: self)
                            AddChecklistViewIconSelector(icon: "building.columns", delegate: self)
                        }
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            AddChecklistViewIconSelector(icon: "music.note", delegate: self)
                            AddChecklistViewIconSelector(icon: "music.mic", delegate: self)
                            AddChecklistViewIconSelector(icon: "megaphone", delegate: self)
                            AddChecklistViewIconSelector(icon: "mic", delegate: self)
                            AddChecklistViewIconSelector(icon: "camera", delegate: self)
                            AddChecklistViewIconSelector(icon: "signpost.right", delegate: self)
                            AddChecklistViewIconSelector(icon: "sportscourt", delegate: self)
                        }
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            AddChecklistViewIconSelector(icon: "bed.double", delegate: self)
                            AddChecklistViewIconSelector(icon: "flashlight.on.fill", delegate: self)
                            AddChecklistViewIconSelector(icon: "gauge", delegate: self)
                            AddChecklistViewIconSelector(icon: "speedometer", delegate: self)
                            AddChecklistViewIconSelector(icon: "barometer", delegate: self)
                            AddChecklistViewIconSelector(icon: "bandage", delegate: self)
                            AddChecklistViewIconSelector(icon: "cross.case", delegate: self)
                            AddChecklistViewIconSelector(icon: "wrench.and.screwdriver", delegate: self)
                            AddChecklistViewIconSelector(icon: "lock", delegate: self)
                            AddChecklistViewIconSelector(icon: "key", delegate: self)
                        }
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            AddChecklistViewIconSelector(icon: "shield", delegate: self)
                            AddChecklistViewIconSelector(icon: "point.topleft.down.curvedto.point.bottomright.up", delegate: self)
                            AddChecklistViewIconSelector(icon: "shippingbox", delegate: self)
                            AddChecklistViewIconSelector(icon: "clock", delegate: self)
                            AddChecklistViewIconSelector(icon: "banknote", delegate: self)
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
