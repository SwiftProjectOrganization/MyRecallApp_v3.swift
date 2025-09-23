//
//  ManageTopicsView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 2/9/25.
//

import SwiftUI
import SwiftData
import OpenAPIRuntime
import OpenAPIURLSession

@MainActor
struct ManageTopicsView {
  @AppStorage("dirName") private var dirName = "MyRecallApp/Data"
  @AppStorage("urlPath") private var urlPath = serverPath
  @AppStorage("remote") private var remote = "false"
 
  @State private var isHelpShown: Bool = false
  
  @State private var result: String = "No responses yet"

  @State private var selection: Set<Topic> = []
  @State private var jsonFiles: [String] = []
  
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss
  @Query private var topics: [Topic]
  @Query private var subTopics: [SubTopic]
  @Query private var questions: [Question]
  
  let client: any APIProtocol
  init(client: any APIProtocol) { self.client = client }
  init() {
    self.init(
      client: Client(serverURL: URL(string: serverPath)!,
                     transport: URLSessionTransport())
    )
  }
}

extension ManageTopicsView {
  private var sortedTopics: [Topic] {
    topics.sorted { $0.title ?? "" < $1.title ?? "" }
  }
}

extension ManageTopicsView {
  private var exportButtonText: String {
    if remote == "false" || remote == "False" {
      "Export\n(local)"
    } else {
      "Export\n(remote)"
    }
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
        MRAButton(label: "Delete\nselection(s)",
                  isDisabled: selection.isEmpty) {
          deleteSelectedTopics(topics: selection)
        }
        Spacer()
        MRAButton(label: exportButtonText,
                  isDisabled: selection.isEmpty) {
          if remote == "false" || remote == "False" {
            writeJSONFiles(topics: selection,
                           path: dirName)
          } else {
            Task { await exportJSONFiles(topics: selection,
                                         path: dirName) }
          }
        }
        Spacer()
      }
      HStack {
        if remote == "true" || remote == "True" {
          Text(result)
            .padding()
        }
      }
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
      }
    }
    .sheet(isPresented: $isHelpShown) {
      ManageTopicsViewHelpScreen()
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

extension ManageTopicsView {
  func exportJSONFiles(topics: Set<Topic>,
                      path: String = "MyRecallApp/Data") async {
    for topic in topics {
      let trimmed = topic.title!.trimmingCharacters(in: .whitespacesAndNewlines)
        .replacingOccurrences(of: " ", with: "_")
      
      let json = createJSONstring(topic: topic)
      do {
        let response = try await client.putJson(
          query: .init(user: "Rob",
                       topic: trimmed,
                       content: json))
          result = try response.ok.body.json.message
      } catch {
        result = "Error: \(error.localizedDescription)"
      }
    }
  }
}

#Preview {
  ManageTopicsView()
    .modelContainer(previewContainer)
}
