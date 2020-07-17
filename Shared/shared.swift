//
//  shared.swift
//  Checklist
//
//  Created by Miguel Themann on 16.07.20.
//

import Foundation

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
