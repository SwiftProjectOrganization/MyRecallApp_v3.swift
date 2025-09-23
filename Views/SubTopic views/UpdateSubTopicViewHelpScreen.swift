//
//  UpdateSubTopicViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct UpdateSubTopicViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension UpdateSubTopicViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Update category*"))
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
  UpdateSubTopicViewHelpScreen()
}

fileprivate let helpText = """

\n1. Update the (possibly 2 part) "**subtopic title**".
\n\n*If the parts are separated by " - " the second part will sometimes be shown as a subtitle for the subtopic.*
\n\n**Note:** *Updating a subtopic title will apply to all questions. Currently it is not possible to move a question to a different subtopic or adding a question to multiple subtopics*.
\n\n2. Set or unset "**Active in recall**".
\n\n3. Click on "***Save***" to update the **subtopic title** and/or the **Active in recall**" setting.
\n\n4. Tab "***Cancel***" or "***<***" (or swipe down the screen) to remove the screen ***without saving***.
"""
