//
//  ActionViewController.swift
//  ChecklistActionExtension
//
//  Created by Miguel Themann on 18.07.20.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Parsing data.."
        
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(String(kUTTypeText)) {
                    provider.loadItem(forTypeIdentifier: String(kUTTypeText), options: nil) { data, error in
                        if let string = data as? String{
                            MarkdownParser().parseChecklist(from: string) { checklist in
                                if let checklist = checklist {
                                    let wrapper = ChecklistsWrapper()
                                    print(wrapper.checklists)
                                    wrapper.checklists.append(checklist)
                                    print(wrapper.checklists)
                                    wrapper.save()
                                    self.label.text = "Saved checklist."
                                    print(try? JSONDecoder().decode([Checklist].self, from: UserDefaults().data(forKey: "checklists") ?? Data()))
                                } else {
                                    self.label.text = "Unable to parse checklist. We support Markdown."
                                }
                            }
                        }
                        else {
                            self.label.text = "Input not valid. Please close this sheet."
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
}
