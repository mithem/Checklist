//
//  MarkdownParserTests.swift
//  ChecklistTests
//
//  Created by Miguel Themann on 18.07.20.
//

import XCTest
@testable import Checklist

class MarkdownParserTests: XCTestCase {
    
    //https://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift
    func randomString(of length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
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
    
    func testParseChecklistPerformanceShort() {
        
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
        
        measure {
            let theExpectation = expectation(description: "got checklist")
            parser.parseChecklist(from: input) { _ in
                print("Got it")
                theExpectation.fulfill()
            }
            waitForExpectations(timeout: 1)
        }
    }
    
    func testParseChecklistPerformanceLong() {
        var input = "# My Checklist (0/0)\n"
        let tCount = 100
        let sCount = 100
        
        for _ in 0..<100 {
            input.append("\n" + randomString(of: 100))
        }
        
        for s in 1...sCount {
            input.append("\n\n## Section \(s)")
            for t in 1...tCount {
                input.append("\n\n- [x] S\(s) T\(t)")
            }
        }
        
        measure {
            let theExpectation = expectation(description: "got checklist")
            parser.parseChecklist(from: input) { checklist in
                print("Got it")
                XCTAssertEqual(checklist?.sections.count ?? 0, sCount + 1)
                XCTAssertEqual(checklist?.sections.first?.items.count ?? 0, tCount)
                theExpectation.fulfill()
            }
            waitForExpectations(timeout: 1)
        }
    }
}
