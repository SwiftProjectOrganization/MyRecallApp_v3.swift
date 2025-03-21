//
//  ManageTopicsViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct ManageTopicsViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension ManageTopicsViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*Manage topics*"))
              .font(.title.bold())
              .padding(.horizontal)
              .multilineTextAlignment(.center)
            Spacer()
          }
        }
        Text("""
           \n**Note 1:** When the app is backgrounded, a new set of .json files is created.
           \n**Note 2:** If a topic is deleted, all subtopics and questions belonging to that topic will also be deleted. A backup .json file will be created in the 'MyRecallApp/Data' folder in the app's container.
           \n**Note 3:** Use "***Import***" to restore topics.
           """)
        .padding()
        .font(.footnote)
        .foregroundStyle(.red)
        
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
  ManageTopicsViewHelpScreen()
}

fileprivate let helpText = """
\n1. Click on "***Edit***" to select one or more topics.
\n\n2. Click on "***Delete***" to delete the selected topics.
\n\n3. Click on "***Export***" to export the selected topics.
\n\n4. Click on "***Import***" to invoke the import screen.
\n\n Both "***Delete***" and "***Export***" are disabled if no selection has been made using "***Edit***". "***Import***" is disabled if no .json files are found.
"""
