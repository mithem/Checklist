//
//  shared.swift
//  Checklist
//
//  Created by Miguel Themann on 16.07.20.
//

import Foundation
import UIKit

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

func getBlueprint(from checklist: Checklist) -> ChecklistBlueprint{
    var section: SectionBlueprint
    var blueprint = ChecklistBlueprint(icon: checklist.icon, name: checklist.name, sections: [])
    for sectionIterator in checklist.sections {
        section = SectionBlueprint(name: sectionIterator.name)
        for item in sectionIterator.items {
            section.items.append(ChecklistBlueprintItem(title: item.title))
        }
        blueprint.sections.append(section)
    }
    return blueprint
}

func getChecklist(from blueprint: ChecklistBlueprint) -> Checklist {
    var section: Section
    let checklist = Checklist(icon: blueprint.icon, name: blueprint.name)
    for sectionIterator in blueprint.sections {
        section = Section(name: sectionIterator.name)
        for item in sectionIterator.items {
            section.items.append(ChecklistItem(title: item.title))
        }
        checklist.sections.append(section)
    }
    return checklist
}

fileprivate func createProjectInThings(_ project: ThingsProject, completion: @escaping (Bool) -> Void) {
    guard let string = String(data: (try? JSONEncoder().encode([project])) ?? Data(), encoding: .utf8) else { return }
    guard let encodedString = string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
    let urlString = "things:///json?data=\(encodedString)"
    guard let url = URL(string: urlString) else { print("Bad URL"); completion(false); return }
    UIApplication.shared.open(url) { success in
        completion(success)
    }
}

func exportToThings(checklist: Checklist) {
    var items = [ThingsItem]()
    for section in checklist.sections {
        items.append(ThingsItem(type: "heading", attributes: ThingsItemAttributes(title: section.name.replacingOccurrences(of: " ", with: "%20"))))
        for item in section.items {
            items.append(ThingsItem(type: "to-do", attributes: ThingsItemAttributes(title: item.title.replacingOccurrences(of: " ", with: "%20"))))
        }
    }
    let project = ThingsProject(type: "project", attributes: ThingsProjectAttributes(title: checklist.name.replacingOccurrences(of: " ", with: "%20"), items: items))
    createProjectInThings(project) { print($0) }
}
