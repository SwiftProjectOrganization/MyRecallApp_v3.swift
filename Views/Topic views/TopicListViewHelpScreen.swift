//
//  TopicListViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct TopicListViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension TopicListViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Topic list*"))
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
        Text(LocalizedStringResource(stringLiteral: helpText2))
          .font(.body)
          .padding(.vertical)
          .foregroundStyle(.red)
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
  TopicListViewHelpScreen()
}

fileprivate let helpText = """
\n1. Tap on a topic to show the list of available subtopics.
\n2. Tap on "**+**" to add a topic.
\n3. Tap on "**Person**" to go to settings.
\n4. Press "***Start recall***" to start reviewing questions.
\n5. Press "***Manage topics***" to delete or export topics.
\n6. Press "***Import (...)***" to import topics. Use "***Person***" (settings) to switch (...) between local and remote.
"""

fileprivate let helpText2 = """
\n ***Note:*** If "***Import (...)***" is disabled, use "***Manage topics***" to export one or more topics.
"""
