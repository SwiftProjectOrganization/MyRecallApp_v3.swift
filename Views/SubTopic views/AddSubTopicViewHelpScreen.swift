//
//  AddSubTopicViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct AddSubTopicViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension AddSubTopicViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Add a category*"))
              .font(.title.bold())
              .padding(.horizontal)
              .multilineTextAlignment(.center)
            Spacer()
          }
        }
        Text(LocalizedStringResource(stringLiteral: helpText))
          .font(.body)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            dismiss()
          } label: {
            Label("Back", systemImage: "lessthan")
          }
        }
      }
      .foregroundColor(.primary.opacity(0.7))

    }
  }
}

#Preview {
  AddSubTopicViewHelpScreen()
}

fileprivate let helpText = """
\n1. Enter a (possibly 2 part) subtopic title, e.g. "Essentials 1 - Sleep".
\n\n*If the parts are separated by " - " the second part will occasionally show up as a subtitle.*
\n\n2. Click on "***Save***"  or "return" to create a new subtopic. 
\n\nNotice that "***Save***" and "return" are disabled when the subtopic field is empty.
\n\n3. Tab "***Cancel***" or "***<***" (or swipe down the screen) to remove the screen ***without saving***.
"""
