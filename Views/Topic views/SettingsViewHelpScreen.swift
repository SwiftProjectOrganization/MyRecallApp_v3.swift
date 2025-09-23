//
//  TopicListViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/14/25.
//

import SwiftUI

struct SettingsViewHelpScreen: View {
  @Environment(\.dismiss) var dismiss
}

extension SettingsViewHelpScreen {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text(LocalizedStringResource(stringLiteral: "Help screen for:\n*App settings*"))
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
  SettingsViewHelpScreen()
}

fileprivate let helpText = """
\n\n1. MyRecallApp export (and import) path. This can be local or remote.
\n\n2. No of recall timestamps to store.
\n\n3. Export locally or remotely.
\n\n4. Default user name.
\n\n5. New server url for remote exports and imports.
\n For more details, click [here](https://github.com/SwiftProjectOrganization/MyRecallAppService/blob/main/README_MyRecallApp.md).
"""
