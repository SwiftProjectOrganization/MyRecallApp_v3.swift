//
//  QuestionListViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct QuestionListViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension QuestionListViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Question List*"))
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
    .foregroundColor(.primary.opacity(0.8))
  }
}

#Preview {
  QuestionListViewHelpScreen()
}

fileprivate let helpText = """
\n1. Tab "***+***" to add questions.
\n\n2. Tab "***Edit***" to remove questions.
\n\n3. Click on "***>***" to see the question details.
\n\n4. Press "***< Back***" (or pull this sheet down) to return to the Category view.
\n\n5. Tap "**Update subtopic**" to modify the current category.
\n\n6. Tap "**Show subtopic links**" to select or update the links.
\n\n7. Tap "**Show subtopic recall timestamps**" to see when this subtopic was included in a recall.
"""
