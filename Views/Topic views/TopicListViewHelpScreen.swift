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
  TopicListViewHelpScreen()
}

fileprivate let helpText = """
\n1. Tap on a topic to show the list of available subtopics.
\n ***If the topic list is not visible on an iPad, press on the sidebar symbol.***
\n\n2. tap on "**+**" to add a topic.
\n\n3. Press "***Start recall***" to start reviewing questions.
\n\n4. Press "***Manage topics***" to delete, export or import topics.
"""
