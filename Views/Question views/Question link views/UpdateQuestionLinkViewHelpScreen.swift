//
//  UpdateQuestionLinksViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct UpdateQuestionLinksViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension UpdateQuestionLinksViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Updating links\n(question)*"))
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
  UpdateQuestionLinksViewHelpScreen()
}

fileprivate let helpText = """
\n1. Press "***+***" to add a link.
\n\n2. Press "***Edit***" to delete links.
\n\n3. Select a link to go to an external website.
\n\n4. Select a link's "***>***" to update the link.
\n\n5. Click on "***Save***" to update the **question title** and/or the **Active in recall**" setting.
\n\n6. Tab "***<***" (or swipe down the screen) to remove the screen ***without saving***.
"""
