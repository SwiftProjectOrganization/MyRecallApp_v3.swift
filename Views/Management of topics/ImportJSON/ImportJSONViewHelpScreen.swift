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
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Import selected\nJSON files*"))
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
  ImportJSONViewHelpScreen()
}

fileprivate let helpText = """
\n1 Select one ot more categories by tapping on "**Edit**".
\n\n2. Click on "**Import selected categories**" to write JSON files for all selected categories. This button is disabled if no categies have been selected.
\n\n3. Press "**<**" or "**Cancel**" (or swipe the form down) to return to the main screen.
"""

