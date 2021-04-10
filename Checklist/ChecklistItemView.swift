//
//  ChecklistItemView.swift
//  Checklist
//
//  Created by Miguel Themann on 13.08.20.
//

import SwiftUI

struct ChecklistItemView: View {
    
    let checklistItem: ChecklistItem
    let delegate: ChecklistItemViewDelegate
    let sectionId: UUID
    
    @State private var checkedValue = false
    
    init(sectionId: UUID, item: ChecklistItem, initialChecked: Bool, delegate: ChecklistItemViewDelegate) {
        self.sectionId = sectionId
        self.delegate = delegate
        self.checklistItem = item
        self.checkedValue = initialChecked
    }
    
    var body: some View {
        HStack {
            Image(systemName: checkedValue ? "checkmark.circle" : "circle")
                .foregroundColor(checkedValue ? .secondary : .primary)
                .onTapGesture {
                    checkedValue.toggle()
                    delegate.checkItem(sectionId: sectionId, id: checklistItem.id, checked: checkedValue)
                }
            Text(checklistItem.title)
                .foregroundColor(checklistItem.checked ? .secondary : .primary)
        }
    }
}

protocol ChecklistItemViewDelegate {
    func checkItem(sectionId: UUID, id: UUID, checked: Bool)
}

struct ChecklistItemView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistItemView(sectionId: UUID(), item: checklistForPreviews.sections.first!.items.first!, initialChecked: true, delegate: self as! ChecklistItemViewDelegate)
    }
}

extension ChecklistItemView_Previews: ChecklistItemViewDelegate {
    func checkItem(sectionId: UUID, id: UUID, checked: Bool) {}
}
