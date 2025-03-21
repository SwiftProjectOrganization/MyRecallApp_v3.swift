//
//  AddQuestionViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct AddQuestionViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension AddQuestionViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Add a question*"))
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
  AddQuestionViewHelpScreen()
}

fileprivate let helpText = """
\n1. Enter a question title.
\n\n2. Provide an answer to the question.
\n\n3. Click on "***Save***" to create a new question and it's answer. Notice that "***Save***" is disabled when the field is empty.
\n\n4. Tab "***Cancel***" or "***<***" (or swipe down the screen) to remove the screen ***without saving***.
"""
