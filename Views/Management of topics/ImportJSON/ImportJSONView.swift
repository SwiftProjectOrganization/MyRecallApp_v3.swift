//
//  ImportJSONView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/27/25.
//

import SwiftUI
import SwiftData

struct ImportJSONView: View {
  @AppStorage(wrappedValue: "MyRecallApp/Data", .settingsDirNameKey) private var dirName: String

  @Binding var isImportJSONShown: Bool
  @State private var isHelpShown: Bool = false
  @State private var selection = Set<URL>()
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss
}

extension ImportJSONView {
  var body: some View {
    NavigationStack {
      HStack {
        Spacer()
        Text("Select topics to import:")
          .font(.title.bold())
          .foregroundColor(.primary.opacity(0.7))
        Spacer()
      }
      List(getJSONFiles(path: dirName)!, id: \.self, selection: $selection) { url in
        Text(url.path.split(separator: "/").last!.replacingOccurrences(of: "_", with: " "))
      }
      //.navigationTitle("Import selection list:")
      Spacer()
        .sheet(isPresented: $isHelpShown) {
          ImportJSONViewHelpScreen()
        }
      HStack {
        Spacer()
        Button("Cancel") {
          dismiss()
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
        Button("Import selected topics") {
          getTopics()
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        .disabled(selection.isEmpty)
        .padding()
        .headerProminence(.increased)
        Spacer()
      }
      Spacer(minLength: 20.0)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            dismiss()
          } label: {
            Label("Back", systemImage: "lessthan")
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          EditButton()
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isHelpShown = true
          } label: {
            Label("Help", systemImage: "questionmark")
          }
        }
      }
    }
  }
}

extension ImportJSONView {
  func getTopics() {
    isImportJSONShown = false
    for selected in selection {
      context.insert(importJSONFiles(urls: [selected]).first!)
    }
  }
}

#Preview {
  ImportJSONView(isImportJSONShown: .constant(false))
}
