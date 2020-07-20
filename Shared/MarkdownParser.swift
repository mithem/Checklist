//
//  MarkdownParser.swift
//  Checklist
//
//  Created by Miguel Themann on 19.07.20.
//

import Foundation

/// Parser for Markdown as provided by Thing's Share Sheet
struct MarkdownParser {
    
    static let _emojiRegex = NSRegularExpression("[\\U00010000-\\U0010FFFF]")
    static let _singleWordChar = #"[\w\s\d@ß?=!\^°\"\'§\$%\/\(\)]"#
    static let _checklistItemRegex = NSRegularExpression(#"- \[[+ x]?\] ("# + _singleWordChar + #"+)"#)
    static let _projectRegex = NSRegularExpression(#"# ("# + _singleWordChar + #"+) \([\d]+\/[\d]+\)"#)
    static let _headingRegex = NSRegularExpression(#"## ("# + _singleWordChar + #"+)"#)
    
    func _countFromBeginning(of string: String, character: Character) -> Int {
        guard !string.isEmpty else { return 0 }
        var i = 0
        func countUp() {
            if string[i] == character {
                i += 1
                if i < string.count {
                    countUp()
                }
            }
        }
        countUp()
        return i
    }
    
    func parseChecklist(from text: String, callback: @escaping (Checklist?) -> Void) {
        let text = MarkdownParser._emojiRegex.stringByReplacingMatches(in: text, range: NSRange(location: 0, length: text.count), withTemplate: "")
        
        let lastLine = text.split(separator: "\n").last!
        
        var nHash = 0
        var item = ChecklistItem(title: "My item")
        var notSectionedItems = [ChecklistItem]()
        var section: Section? = nil
        var checklist: Checklist? = nil
        text.enumerateLines { line, stop in
            nHash = _countFromBeginning(of: line, character: "#")
            switch nHash {
            case 0:
                if line.starts(with: "- [") {
                    guard let result = MarkdownParser._checklistItemRegex.firstMatch(in: line, range: NSRange(location: 0, length: line.count)) else { return }
                    let nsRange = result.range(at: 1)
                    guard let range = Range(nsRange) else { return }
                    let name = line[range]
                    let importantChar = line[3].lowercased()
                    item = ChecklistItem(title: String(name), checked: importantChar == "+" || importantChar == "x")
                    if let section = section {
                        section.items.append(item)
                    } else {
                        notSectionedItems.append(item)
                    }
                }
            case 1:
                guard let result = MarkdownParser._projectRegex.firstMatch(in: line, range: NSRange(location: 0, length: line.count)) else { return }
                let nsRange = result.range(at: 1)
                guard let range = Range(nsRange) else { return }
                let name = line[range]
                checklist = Checklist(icon: "checkmark", name: String(name))
            case 2:
                guard let result = MarkdownParser._headingRegex.firstMatch(in: line, range: NSRange(location: 0, length: line.count)) else { return }
                let nsRange = result.range(at: 1)
                guard let range = Range(nsRange) else { return }
                let name = line[range]
                if let checklist = checklist {
                    if let section = section {
                        checklist.sections.append(section)
                    }
                }
                section = Section(name: String(name))
            default: // assume empty line or description
                break
            }
            if line == lastLine {
                if let section = section {
                    checklist?.sections.append(section)
                }
                section = Section(name: "My Section", items:notSectionedItems)
                checklist?.sections.append(section!)
                callback(checklist)
            }
        }
    }
}
