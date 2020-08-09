//
//  GalleryView.swift
//  Checklist
//
//  Created by Miguel Themann on 16.07.20.
//

import SwiftUI

struct GalleryView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var wrapper: ChecklistsWrapper
    
    var body: some View {
        Group {
            if wrapper.galleryChecklists.count > 0 {
                List {
                    ForEach(wrapper.galleryChecklists) { blueprint in
                        GalleryItemView(checklist: blueprint, delegate: self)
                    }
                    .onDelete(perform: removeGalleryItems)
                }
                .listStyle(InsetGroupedListStyle())
                .animation(.easeInOut)
            }
            else {
                VStack {
                    HStack {
                        Text("Tap")
                        Image(systemName: "plus")
                            .padding(5)
                            .background(Color.gray.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        Text("to add checklists in here.")
                    }
                    Text("You can find it next to the icon for the checklist.")
                }
                .padding()
            }
        }
        .navigationTitle("Gallery")
        .navigationBarItems(trailing: EditButton())
    }
    
    func removeGalleryItems(offsets: IndexSet) {
        wrapper.galleryChecklists.remove(atOffsets: offsets)
        wrapper.save()
    }
}

extension GalleryView: GalleryItemViewDelegate {
    func add(blueprint: ChecklistBlueprint) {
        let checklist = getChecklist(from: blueprint)
        wrapper.checklists.append(checklist)
        wrapper.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(wrapper: ChecklistsWrapper())
    }
}
