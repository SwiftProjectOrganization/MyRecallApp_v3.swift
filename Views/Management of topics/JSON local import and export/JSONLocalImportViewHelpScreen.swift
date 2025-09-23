//
//  ImportJSONViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 2/1/25.
//

import SwiftUI

struct ImportJSONViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension ImportJSONViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Import*"))
              .font(.title.bold())
              .padding(.horizontal)
              .multilineTextAlignment(.center)
              .foregroundStyle(.blue)
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
  ImportJSONViewHelpScreen()
}

fileprivate let helpText = """
\n1. Select one or more of the available topics by tapping on "**Edit**" or select a single topic.
\n\n2. Click on "**Import selected topics**" to create all selected topics. This button is disabled if no topics have been selected.
\n\n3. Press "**<**" or "**Cancel**" (or swipe the form down) to return to the main screen.
"""

