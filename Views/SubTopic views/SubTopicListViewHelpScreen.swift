//
//  SubTopicListViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct SubTopicListViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension SubTopicListViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Subtopic list*"))
              .font(.title.bold())
              .padding(.horizontal)
              .multilineTextAlignment(.center)
            Spacer()
          }
        }
        Text(LocalizedStringResource(stringLiteral: helpText))
          .font(.body)
          .padding(.vertical)
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
  SubTopicListViewHelpScreen()
}

fileprivate let helpText = """
\n1. Tap on a subtopic item to show a list of questions.
\n\n2. Tap on "**+**" to add subtopics.
\n\n **Note:** If tou delete a subtopic, all it's questions will also be deleted.
\n\n3. Tab "**Edit**" to update the subtopic list.
\n\n4. Click "***< Back***" (or pull down the screen) to remove a help screen.
"""
