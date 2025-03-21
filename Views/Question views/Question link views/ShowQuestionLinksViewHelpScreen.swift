//
//  ShowQuestionLinksViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct ShowQuestionLinksViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension ShowQuestionLinksViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Show question links*"))
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
    }
    .foregroundStyle(.primary.opacity(0.8))
  }
}

#Preview {
  ShowQuestionLinksViewHelpScreen()
}

fileprivate let helpText = """
\n*This sheet allows updating both the link phrase and the link type.*
\n\n**Note:** Link markup can be used in this field, e.g. `"[Apple](https://apple.com)"`.
\n\n1. To update the link phrase, edit the top field.
\n\n2. To assign a new link type, click on the leftmost field in the bottom bordered area.
\n\n3. Click on "***Save***" to update both fields**.
\n\n4. Tab "***< Back***" or "***Cancel***" (or swipe down the screen) to remove the screen ***without saving***.
"""
