//
//  ManageTopicsView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 2/9/25.
//

import SwiftUI
import SwiftData

struct ManageTopicsView {
  @AppStorage(wrappedValue: "MyRecallApp/Data", .settingsDirNameKey) private var dirName: String

  @State private var isHelpShown: Bool = false
  @State private var isImportJSON: Bool = false
  @State private var showSettingsSheet: Bool = false
  
  @State private var selection: Set<Topic> = []
  
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss
  @Query private var topics: [Topic]
  @Query private var subTopics: [SubTopic]
  @Query private var questions: [Question]
}

extension ManageTopicsView {
  private var sortedTopics: [Topic] {
    topics.sorted { $0.title ?? "" < $1.title ?? "" }
  }
}

extension ManageTopicsView {
  private var sortedSubTopics: [SubTopic] {
    subTopics.sorted { $0.title ?? "" < $1.title ?? "" }
  }
}

extension ManageTopicsView {
  private var filteredQuestions: [Question] {
    questions.filter { $0.includedInRecall && $0.subTopic!.includedInRecall}
  }
}

extension ManageTopicsView: View {
  var body: some View {
    NavigationStack() {
      HStack {
        Spacer()
        Text("Manage topics")
          .font(.title.bold())
          .foregroundColor(.secondary.opacity(0.7))
          .multilineTextAlignment(.center)
        Spacer()
      }
      Text("""
         \n**Note:** See help ( **?** ) to understand deletion of topics.
         """)
      .padding()
      .font(.footnote)
      .foregroundStyle(.red)
      HStack {
        Spacer()
        Text("\nSelect topics:")
          .font(.title)
          .foregroundColor(.primary.opacity(0.7))
          .multilineTextAlignment(.center)
        Spacer()
      }
      List(sortedTopics, id: \.self, selection: $selection) { topic in
        Text(topic.title!)
      }
      Spacer()
      Text("Number of selected topics: \(selection.count)")
      HStack {
        Spacer()
        Button("Delete") {
          deleteSelectedTopics(topics: selection)
        }
        .disabled(selection.isEmpty)
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
        Button("Export") {
          writeJSONFiles(topics: selection,
                         path: dirName)
        }
        .disabled(selection.isEmpty)
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
        Button("Import") {
          isImportJSON = true
        }
        .disabled(getJSONFiles(path: dirName) == nil || getJSONFiles(path: dirName)!.count <= 0)
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
      }
      .padding()
      .headerProminence(.increased)
      .padding(.horizontal)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
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
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            showSettingsSheet = true
          } label: {
            Label("Settings", systemImage: "person.crop.circle")
          }
        }
      }
    }
    .sheet(isPresented: $isHelpShown) {
      ManageTopicsViewHelpScreen()
    }
    .sheet(isPresented: $isImportJSON) {
      ImportJSONView(isImportJSONShown: $isImportJSON)
    }
    .sheet(isPresented: $showSettingsSheet) {
      SettingsView()
    }
  }
}

extension ManageTopicsView {
  func deleteSelectedTopics(topics: Set<Topic>) {
    writeJSONFiles(topics: topics,
                   path: dirName)
    for topic in topics {
      context.delete(topic)
    }
  }
}

#Preview {
  ManageTopicsView()
    .modelContainer(previewContainer)
}
