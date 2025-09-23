//
//  UpdateMainTopicViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct UpdateMainTopicViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension UpdateMainTopicViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Update topc*"))
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
    .foregroundStyle(.primary.opacity(0.7))
  }
}

#Preview {
  UpdateMainTopicViewHelpScreen()
}

fileprivate let helpText = """

\n1. Update the 2 part "**category title**".
\n\n*If the parts are separated by ": " (a colon and a space), in the future the second part will be shown as a sub-category.*
\n\n**Note:** *Updating a category title will apply to all questions. Currently it is not possible to move a question to a different category or adding a question to multiple categories*.
\n\n2. Set or unset "**Active in recall**".
\n\n3. Click on "***Save***" to update the **category title** and/or the **Active in recall**" setting.
\n\n4. Tab "***Cancel***" or "***<***" (or swipe down the screen) to remove the screen ***without saving***.
"""
