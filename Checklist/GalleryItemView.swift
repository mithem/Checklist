//
//  GalleryItemView.swift
//  Checklist
//
//  Created by Miguel Themann on 16.07.20.
//

import SwiftUI

struct GalleryItemView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let checklist: ChecklistBlueprint
    
    let delegate: GalleryItemViewDelegate
    
    var body: some View {
        HStack {
            Image(systemName: checklist.icon)
            Text(checklist.name)
        }
        .onTapGesture {
            delegate.add(blueprint: checklist)
        }
    }
}

protocol GalleryItemViewDelegate {
    func add(blueprint: ChecklistBlueprint)
}

struct GalleryItemView_Previews: PreviewProvider, GalleryItemViewDelegate {
    func add(blueprint: ChecklistBlueprint) {}
    static var previews: some View {
        GalleryItemView(checklist: checklistBlueprintForPreviews, delegate: self as! GalleryItemViewDelegate)
    }
}
