//
//  UpdateCategoryViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct UpdateTopicViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension UpdateTopicViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Update topic*"))
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
  UpdateTopicViewHelpScreen()
}

fileprivate let helpText = """

\n1. Update the "**topic title**".
\n\n **Note:** *Updating a topic title will apply to all subtopics. Currently it is not possible to move a subtopic to a different topic or adding a subtopic to multiple topics*.
\n\n2. Set or unset "**Active in recall**".
\n\n3. Click on "***Save***" to update the **category title** and/or the **Active in recall**" setting.
\n\n4. Tab "***Cancel***" or "***<***" (or swipe down the screen) to remove the screen ***without saving***.
"""
