//
//  UpdateQuestionViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct UpdateQuestionViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension UpdateQuestionViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Update question*"))
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
  UpdateQuestionViewHelpScreen()
}

fileprivate let helpText = """
\n1. Update the "**question title**".
\n\n2. Update the "**answer**".
\n\n3. Click on "***Save***" to save the changes.
\n\n4. Tab "***Cancel***" or "***<***" (or swipe down the screen) to remove the screen ***without saving***.
"""
