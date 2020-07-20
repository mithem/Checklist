//
//  shared.swift
//  Checklist
//
//  Created by Miguel Themann on 16.07.20.
//

import Foundation

//MARK: Checklist/Blueprint conversion

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

extension String {
    // https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
}

extension NSRegularExpression {
    // https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
}
