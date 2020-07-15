//
//  CheckToggle.swift
//  Checklist
//
//  Created by Miguel Themann on 15.07.20.
//

import SwiftUI

struct CheckToggle: View {
    
    @State var value = false
    
    let callback: (Bool) -> Void
    
    var imgString: String {
        if value {
            return "checkmark.circle"
        } else {
            return "circle"
        }
    }
    
    var body: some View {
        Image(systemName: imgString)
            .foregroundColor(value ? .secondary : .primary)
            .onTapGesture {
                value.toggle()
                callback(value)
            }
    }
}

struct CheckToggle_Previews: PreviewProvider {
    static var previews: some View {
        CheckToggle(value: true) { _ in }
    }
}
