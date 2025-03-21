//
//  AddTopicHelpViewScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 2/6/25.
//

import SwiftUI

struct AddTopicViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension AddTopicViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Add a topic*"))
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
      .foregroundColor(.primary.opacity(0.7))

    }
  }
}

#Preview {
  AddTopicViewHelpScreen()
    .modelContainer(previewContainer)
}

fileprivate let helpText = """
\n1. Enter a topic title, e.g. "Huberman".
\n\n2. Click on "***Save***" or press "enter" to create a new topic. 
\n\nNotice that both "***Save***" and "return" are disabled when the topic title field is empty.
\n\n3. Tab "***Cancel***" or "***<***" (or swipe down the screen) to remove the screen ***without saving***.
"""

