//
//  SubTopicTimeStampsViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct SubTopicTimeStampsViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension SubTopicTimeStampsViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Recall timestamps\n (subtopic)*"))
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
  SubTopicTimeStampsViewHelpScreen()
}

fileprivate let helpText = """
\n*This screen shows recent time stamps when this subtopic was visited in the recall process*.
\n\n1. Tab "***Done***" or ***<***" (or swipe down the screen) to remove the screen.
"""
