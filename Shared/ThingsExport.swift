//
//  ThingsExport.swift
//  Checklist
//
//  Created by Miguel Themann on 18.07.20.
//

import Foundation
import UIKit

//MARK: Data Models

struct ThingsItemAttributes: Encodable {
    var title: String
}

struct ThingsItem: Encodable {
    var type: String
    var attributes: ThingsItemAttributes
}

struct ThingsProjectAttributes: Encodable {
    var title: String
    var items: [ThingsItem]
}

struct ThingsProject: Encodable {
    var type = "project"
    var attributes: ThingsProjectAttributes
}

//MARK:  Data generation

func createThingsProject(from checklist: Checklist) -> ThingsProject {
    var items = [ThingsItem]()
    for section in checklist.sections {
        items.append(ThingsItem(type: "heading", attributes: ThingsItemAttributes(title: section.name)))
        for item in section.items {
            items.append(ThingsItem(type: "to-do", attributes: ThingsItemAttributes(title: item.title)))
        }
    }
    let project = ThingsProject(type: "project", attributes: ThingsProjectAttributes(title: checklist.name, items: items))
    return project
}

func exportToThings(checklist: Checklist) {
    let project = createThingsProject(from: checklist)
    sendToThings([project]) { print($0 ? "Project sent." : "Error sending project.") }
}

//MARK: Data transmission
fileprivate func sendToThings<T: Encodable>(_ data: T, completion: @escaping (Bool) -> Void) {
    guard let string = String(data: (try? JSONEncoder().encode(data)) ?? Data(), encoding: .utf8) else { return }
    guard let encodedString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
    let urlString = "things:///json?data=\(encodedString)"
    guard let url = URL(string: urlString) else { print("Bad URL"); return }
    UIApplication.shared.open(url) { completion($0) }
}
