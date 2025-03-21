//
//  TopicView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 2/6/25.
//

import SwiftUI
import SwiftData

struct TopicListView {
  @AppStorage(wrappedValue: "MyRecallApp/Data", .settingsDirNameKey) private var dirName: String

  // Used to export all topics when app is backgrounded
  @Environment(\.scenePhase) var scenePhase
  
  // Used to trigger sheets
  @State private var isAddTopicSheetShown: Bool = false
  @State private var isHelpScreenShown: Bool = false
  @State private var isManageTopicsScreenShown: Bool = false
  @State private var isRecallScreenShown: Bool = false
  
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

extension TopicListView: View {
  var body: some View {
    NavigationStack() {
      HStack {
        Spacer()
        Text("Topic list:")
          .font(.title.bold())
          .foregroundColor(.primary.opacity(0.7))
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
      }
      Spacer()
      VStack {
        HStack {
          Spacer()
          Button("Start recall") {
            setupRecall()
          }
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
          .multilineTextAlignment(.center)
          .disabled(filteredQuestions.count == 0)
          Spacer()
          Button {
            isManageTopicsScreenShown = true
          } label: {
            Text("Manage topics")
          }
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
          .multilineTextAlignment(.center)
          Spacer()
        }
        .padding()
        .headerProminence(.increased)
        .padding(.horizontal)
        .navigationDestination(for: Topic.self) { topic in
          SubTopicListView(topic: topic)
        }
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
            isHelpScreenShown = true
          } label: {
            Label("Help", systemImage: "questionmark")
          }
        }
      }
    }
    .onChange(of: scenePhase) {
      if scenePhase == .background {
        do {
          try context.save()
        } catch {
          print(error.localizedDescription)
        }
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
