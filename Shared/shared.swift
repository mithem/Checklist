//
//  shared.swift
//  Checklist
//
//  Created by Miguel Themann on 16.07.20.
//

import Foundation

func getBlueprint(from checklist: Checklist) -> ChecklistBlueprint{
    var blueprint = ChecklistBlueprint(icon: checklist.icon, name: checklist.name, items: [])
    for item in checklist.items {
        blueprint.items.append(ChecklistBlueprintItem(title: item.title))
    }
    return blueprint
}

func getChecklist(from blueprint: ChecklistBlueprint) -> Checklist {
    let checklist = Checklist(icon: blueprint.icon, name: blueprint.name)
    for item in blueprint.items {
        checklist.items.append(ChecklistItem(title: item.title))
    }
    return checklist
}
