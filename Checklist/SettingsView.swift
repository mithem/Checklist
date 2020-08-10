//
//  SettingsView.swift
//  Checklist
//
//  Created by Miguel Themann on 17.07.20.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    let wrapper: ChecklistsWrapper
    
    @State private var showingMarkdownCouldNotBeParsedActionSheet = false
    @State private var showingEmptyPasteboardActionSheet = false
    
    var body: some View {
        Form {
            NavigationLink(destination: ExportToThingsView(wrapper: wrapper)) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Export to Things")
                }
            }
            Button("Import Markdown") {
                parseChecklistFromClipboard()
            }
            .actionSheet(isPresented: $showingEmptyPasteboardActionSheet) {
                ActionSheet(title: Text("Empty clipboard/pasteboard"), message: Text("You have no text available in your clipboard/pasteboard. Be sure to try again once you have copied valid markdown"), buttons: [.default(Text("OK"))])
            }
        }
        .onAppear(perform: resetActiveChecklist)
        .navigationTitle("Settings")
        .actionSheet(isPresented: $showingMarkdownCouldNotBeParsedActionSheet) {
            ActionSheet(title: Text("Unable to parse markdown"), message: Text("The text in your clipboard/pasteboard could not be parsed."), buttons: [.default(Text("OK"))])
        }
    }
    
    func parseChecklistFromClipboard() {
        if !UIPasteboard.general.hasStrings {
            showingEmptyPasteboardActionSheet = true
            return
        }
        let markdown = UIPasteboard.general.string ?? ""
        let parser = MarkdownParser()
        parser.parseChecklist(from: markdown) { checklist in
            if let checklist = checklist {
                wrapper.checklists.append(checklist)
                wrapper.save()
                presentationMode.wrappedValue.dismiss()
            } else {
                showingMarkdownCouldNotBeParsedActionSheet = false
            }
        }
    }
}
