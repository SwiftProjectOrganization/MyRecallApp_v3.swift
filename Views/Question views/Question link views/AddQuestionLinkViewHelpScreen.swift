//
//  AddQuestionLinkViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct AddQuestionLinkViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension AddQuestionLinkViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Add a link\n (question)*"))
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
  AddQuestionLinkViewHelpScreen()
}

fileprivate let helpText = """
\n1. Enter a link phrase like:\n `[Apple](https://apple.com)`.
\n\n2. Click on "***Save***" to add the link.
\n\n3. Tab "***<***" (or swipe down the screen) to remove the screen ***without saving***.
"""
