//
//  ThingsExport.swift
//  Checklist
//
//  Created by Miguel Themann on 18.07.20.
//

import Foundation
import UIKit

//MARK: Data Models

fileprivate struct ThingsItemAttributes: Encodable {
    var title: String
}

fileprivate struct ThingsItem: Encodable {
    var type: String
    var attributes: ThingsItemAttributes
}

fileprivate struct ThingsProjectAttributes: Encodable {
    var title: String
    var items: [ThingsItem]
}

fileprivate struct ThingsProject: Encodable {
    var type = "project"
    var attributes: ThingsProjectAttributes
}

enum ThingsExportStyle: String {
    case project = "project"
    case toDos = "toDos"
    
    init(_ style: String) {
        switch(style) {
        case "project":
            self = .project
        case "toDos":
            self = .toDos
        default:
            fatalError("Unvalid ThingsExportStyle specified: \(style)")
        }
    }
}

//MARK:  Data generation
func exportToThings(checklist: Checklist) {
    switch ThingsExportStyle(UserDefaults().string(forKey: "thingsExportStyle") ?? "project") {
    case .project:
        var items = [ThingsItem]()
        for section in checklist.sections {
            items.append(ThingsItem(type: "heading", attributes: ThingsItemAttributes(title: section.name.replacingOccurrences(of: " ", with: "%20"))))
            for item in section.items {
                items.append(ThingsItem(type: "to-do", attributes: ThingsItemAttributes(title: item.title.replacingOccurrences(of: " ", with: "%20"))))
            }
        }
        let project = ThingsProject(type: "project", attributes: ThingsProjectAttributes(title: checklist.name.replacingOccurrences(of: " ", with: "%20"), items: items))
        sendToThings(project) { _ in }
    case .toDos:
        var items = [ThingsItem]()
        for section in checklist.sections {
            items.append(ThingsItem(type: "to-do", attributes: ThingsItemAttributes(title: section.name)))
            for item in section.items {
                items.append(ThingsItem(type: "checklist-item", attributes: ThingsItemAttributes(title: item.title)))
            }
        }
        sendToThings(items) { _ in }
    }
}

//MARK: Data transmission
fileprivate func sendToThings<T: Encodable>(_ data: T, completion: @escaping (Bool) -> Void) {
    guard let string = String(data: (try? JSONEncoder().encode(data)) ?? Data(), encoding: .utf8) else { return }
    guard let encodedString = string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
    let urlString = "things:///json?data=\(encodedString)"
    guard let url = URL(string: urlString) else { print("Bad URL"); return }
    UIApplication.shared.open(url) { completion($0) }
}
