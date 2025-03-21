//
//  QuestionViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct QuestionViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension QuestionViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Questions*"))
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
  QuestionViewHelpScreen()
}

fileprivate let helpText = """
\n1. Press "***< Back***" (or pull this sheet down) to return to the subtopic view.
\n\n2. Tap "**Update question**" to modify the current question.
\n\n3. Tap "**Show question links**" to select or update the links.
\n\n4. Tap "Show question recall timestamps**" to see when this question was included in a recall.
"""
