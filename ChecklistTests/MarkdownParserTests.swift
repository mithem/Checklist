//
//  MarkdownParserTests.swift
//  ChecklistTests
//
//  Created by Miguel Themann on 18.07.20.
//

import XCTest
@testable import Checklist

class MarkdownParserTests: XCTestCase {
    
    let parser = MarkdownParser()
    
    func testCountFromBeginning() {
        XCTAssertEqual(parser._countFromBeginning(of: "hello", character: "h"), 1)
        
        XCTAssertEqual(parser._countFromBeginning(of: "hhhelllo", character: "h"), 3)
        
        XCTAssertEqual(parser._countFromBeginning(of: "hello", character: "a"), 0)
        
        XCTAssertEqual(parser._countFromBeginning(of: "# My Project", character: "#"), 1)
        
        XCTAssertEqual(parser._countFromBeginning(of: "## My Section", character: "#"), 2)
    }
    
    func testRegexs() {
        var string: String
        var result: NSTextCheckingResult?
        var range: NSRange {
            NSRange(location: 0, length: string.count)
        }
        
        print(MarkdownParser._checklistItemRegex.pattern)
        
        string = "# hello there (200/206)"
        result = MarkdownParser._projectRegex.firstMatch(in: string, range: range)
        XCTAssertNotNil(result, "No match found.")
        if let result = result {
            XCTAssertEqual(string[Range(result.range(at: 1))!], "hello there")
        }
        
        string = "# Another / Project (200/206)"
        result = MarkdownParser._projectRegex.firstMatch(in: string, range: range)
        XCTAssertNotNil(result, "No match found.")
        if let result = result {
            XCTAssertEqual(string[Range(result.range(at: 1))!], "Another / Project")
        }
        
        string = "- [+] Example task 1"
        result = MarkdownParser._checklistItemRegex.firstMatch(in: string, range: range)
        XCTAssertNotNil(result, "No match found.")
        if let result = result {
            XCTAssertEqual(string[Range(result.range(at: 1))!], "Example task 1")
        }
        
        string = "- [x] Another task (really!)"
        result = MarkdownParser._checklistItemRegex.firstMatch(in: string, range: range)
        XCTAssertNotNil(result, "No match found.")
        if let result = result {
            XCTAssertEqual(string[Range(result.range(at: 1))!], "Another task (really!)")
        }
        
        string = "- [] My Task"
        result = MarkdownParser._checklistItemRegex.firstMatch(in: string, range: range)
        XCTAssertNotNil(result, "No match found.")
        if let result = result {
            XCTAssertEqual(string[Range(result.range(at: 1))!], "My Task")
        }
        
        string = "## Section 1"
        result = MarkdownParser._headingRegex.firstMatch(in: string, range: range)
        XCTAssertNotNil(result, "No match found.")
        if let result = result {
            XCTAssertEqual(string[Range(result.range(at: 1))!], "Section 1")
        }
        
        string = "## Different@Section"
        result = MarkdownParser._headingRegex.firstMatch(in: string, range: range)
        XCTAssertNotNil(result, "No match found.")
        if let result = result {
            XCTAssertEqual(string[Range(result.range(at: 1))!], "Different@Section")
        }
    }
    
    func testParseChecklist() {
        let input = """
# Some🚀 Project (527/528)

Some description as exported from Things

My checklist (still description)
- item 1
- item 2

- [+] Example task 1

## Section 1

- [ ] Example 🚀task 2

## Sect🎉ion 2

- [] Another task🎉

## Yet another section

- [x] task

## Empty Section

"""
        let theExpectation = expectation(description: "Get parsed checklist")
        
        // Notice that the missing space on l 41 is intended
        // Also, i cannot get the RegEx-engine to accept emojis, therefore some (which it can find are removed from the input text
        let expected = Checklist(icon: "checkmark", name: "Some Project", sections: [Section(name: "My Section", items: [ChecklistItem(title: "Example task 1", checked: true)]), Section(name: "Section 1", items: [ChecklistItem(title: "Example task 2")]), Section(name: "Section 2", items: [ChecklistItem(title: "Another task")]), Section(name: "Yet another section", items: [ChecklistItem(title: "task", checked: true)]), Section(name: "Empty Section")])
        
        parser.parseChecklist(from: input) { checklist in
            if let checklist = checklist {
                XCTAssertEqual(checklist, expected)
                theExpectation.fulfill()
            } else {
                XCTFail("Unable to parse Checklist.")
            }
        }
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error, "Error: \(error?.localizedDescription)")
        }
    }
}
