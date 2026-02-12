//
//  TopicView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 2/6/25.
//

import SwiftUI
import SwiftData
import OpenAPIRuntime
import OpenAPIURLSession

struct TopicListView {
  // Used in remote communications
  @AppStorage("dirName") private var dirName = "MyRecallApp/Data"
  @AppStorage("urlPath") private var urlPath = "http://Rob-Travel-M5.local:8083/api"
  @AppStorage("remote") private var remote = "false"
  
  // Used to export all topics when app is backgrounded
  @Environment(\.scenePhase) var scenePhase
  
  // Used to trigger sheets
  @State private var isAddTopicSheetShown: Bool = false
  @State private var isHelpScreenShown: Bool = false
  @State private var isManageTopicsScreenShown: Bool = false
  @State private var isRecallScreenShown: Bool = false
  @State private var isLocalImportJSON: Bool = false
  @State private var isRemoteImportJSON: Bool = false
  @State private var showSettingsSheet: Bool = false
  
  // Used in remote communications
  @State private var result: String = "No responses yet"
  @State private var jsonFiles: [String] = []
  
  // Used when recalling questions
  @State private var allQuestions: [Question] = []
  @State private var allFilteredQuestions: [Question] = []
  @State private var selectedQuestion: Question? = nil
  @State private var showAnswer: Bool = false
  
  // SwiftData
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

extension TopicListView {
  private var sortedTopics: [Topic] {
    topics.sorted { $0.title ?? "" < $1.title ?? "" }
  }
}

extension TopicListView {
  var topicSet: Set<Topic> {
    Set(topics.map { $0 })
  }
}

extension TopicListView {
  private var filteredQuestions: [Question] {
    questions.filter { $0.includedInRecall &&
      !($0.subTopic == nil) && $0.subTopic!.includedInRecall &&
      !($0.subTopic!.topic == nil) && $0.subTopic!.topic!.includedInRecall }
  }
}

extension TopicListView {
  private var importButtonText: String {
    if remote == "false" || remote == "False" {
      "Import\n(local)"
    } else {
      "Import\n(remote)"
    }
  }
}

extension TopicListView: View {
  var body: some View {
    NavigationStack() {
      HStack {
        Spacer()
        Text("Topic list")
          .font(.title.bold())
          .foregroundStyle(.blue)
        Spacer()
      }
      List {
        ForEach(sortedTopics) { topic in
          NavigationLink(topic.title!,
                         value: topic)
        }
        .onDelete { indexSet in
          if let index = indexSet.first {
            context.delete(topics[index])
          }
        }
      } // End of List
      Spacer()
      VStack {
        HStack {
          Spacer()
          MRAButton(label: "Start\nrecall",
                    isDisabled: filteredQuestions.count == 0) {
            setupRecall()
          }
          Spacer()
          MRAButton(label: "Manage\ntopics") {
            isManageTopicsScreenShown = true
          }
          Spacer()
          MRAButton(label: importButtonText,
                    isDisabled: importFilesAvailable(path: dirName,
                                                     remote: remote)) {
            if remote == "false" || remote == "False" {
              isLocalImportJSON = true
            } else {
              isRemoteImportJSON = true
            }
          }
          Spacer()
        }
      }
      .navigationDestination(for: Topic.self) { topic in
        SubTopicListView(topic: topic)
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isAddTopicSheetShown = true
          } label: {
            Label("Add topics", systemImage: "plus")
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            showSettingsSheet = true
          } label: {
            Label("Settings", systemImage: "person.crop.circle")
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isHelpScreenShown = true
          } label: {
            Label("Help", systemImage: "questionmark")
          }
        }
      } // End of .toolbar
    } // End of NavigationStack
    .task {
      jsonFiles = await getListOfJSONFiles()
    }
    .onChange(of: scenePhase) {
      if scenePhase == .background {
        do {
          try context.save()
        } catch {
          print(error.localizedDescription)
        }
        // Use a Task for below operation?
        // It's a local file write and we're finished using the app.
        writeJSONFiles(topics: topicSet,
                       path: dirName)
      }
    }
    .sheet(isPresented: $isAddTopicSheetShown) {
      AddTopicView()
    }
    .sheet(isPresented: $isManageTopicsScreenShown) {
      ManageTopicsView()
    }
    .sheet(isPresented: $isHelpScreenShown) {
      TopicListViewHelpScreen()
    }
    .sheet(isPresented: $isLocalImportJSON) {
      LocalImportJSONView(isLocalImportJSONShown: $isLocalImportJSON)
    }
    .sheet(isPresented: $isRemoteImportJSON) {
      JSONRemoteImportView()
    }
    .sheet(isPresented: $showSettingsSheet) {
      SettingsView()
    }
    .sheet(isPresented: $isRecallScreenShown) {
      QuestionAndUserAnswerView(isRecallOn: $isRecallScreenShown,
                                questions: $allQuestions,
                                filteredQuestions: $allFilteredQuestions,
                                selectedQuestion: $selectedQuestion,
                                showAnswer: $showAnswer)
    }
  }
}

extension TopicListView {
  func importFilesAvailable(path: String = "MyRecallApp/Data",
                            remote: String) -> Bool {
    if remote == "false" || remote == "False" {
      return getJSONFiles(path: dirName) == nil || getJSONFiles(path: dirName)!.count <= 0
    } else {
      Task {
        jsonFiles = await getListOfJSONFiles()
      }
      return jsonFiles.count <= 0
    }
  }
}

extension TopicListView {
  func getListOfJSONFiles(user: String = "Rob") async -> [String] {
    do {
      let response = try await client.listTopics(
        query: .init(user: user))
      result = try response.ok.body.json.message
      jsonFiles = splitJSONFileNames(str: result)
    } catch {
      result = "Error: \(error.localizedDescription)"
    }
    return jsonFiles
  }
}

extension TopicListView {
  func setupRecall() {
    if questions.count > 0 {
      allQuestions = questions
      allFilteredQuestions = filteredQuestions
      let index = Int.random(in: 0..<filteredQuestions.count)
      selectedQuestion = filteredQuestions[index]
      showAnswer = false
      isRecallScreenShown = true
    }
  }
}

#Preview {
  TopicListView()
    .modelContainer(previewContainer)
}
