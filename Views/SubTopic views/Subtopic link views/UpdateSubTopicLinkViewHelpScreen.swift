//
//  UpdateSubTypeLinkViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct UpdateSubTypeLinkViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension UpdateSubTypeLinkViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Subtopic link*"))
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
      .foregroundColor(.primary.opacity(0.8))
    }
  }
}

#Preview {
  UpdateSubTypeLinkViewHelpScreen()
}

fileprivate let helpText = """
\n*This sheet allows updating both the link phrase and the link type.*
\n\n**Note:** Link markup is used in this field, e.g. `"[Apple](https://apple.com)"`.
\n\n1. To update the link phrase, edit the top field.
\n\n2. To assign a new link type, click on the leftmost field in the bottom bordered area.
\n\n3. Click on "***Save***" to update both fields**.
\n\n4. Tab "***< Back***" or "***Cancel***" (or swipe down the screen) to remove the screen ***without saving***.
"""
