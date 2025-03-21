//
//  QuestionsListView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/29/24.
//

import SwiftUI
import SwiftData

struct QuestionsListView {
  @State private var isUpdatePresented = false
  @State private var areSubTopicTimeStampsVisible = false
  @State private var areSubTopicLinksVisible = false
  @State private var isAddingQuestion = false
  @State private var isHelpShown = false
  @State private var includedInRecall: Bool = true
  @Environment(\.modelContext) var context
  @Environment(\.dismiss) private var dismiss
  @Query var questions: [Question]
  var subTopic: SubTopic
}

extension QuestionsListView {
  private var categoryQuestions: [Question] {
    questions.filter { $0.subTopic == subTopic}.sorted { $0.title! < $1.title! }
  }
}

extension QuestionsListView: View {
  var body: some View {
    VStack {
      HStack {
        Spacer()
        let topic = subTopic.topic!.title!
        VStack {
          HStack {
            Spacer()
            Text("Topic:")
              .font(.body)
              .foregroundColor(.secondary.opacity(0.7))
              .multilineTextAlignment(.center)
            Spacer()
          }
          HStack {
            Spacer()
            Text(topic)
              .font(.body)
              .foregroundColor(.primary.opacity(0.7))
              .multilineTextAlignment(.center)
            Spacer()
          }
          HStack {
            Spacer()
            Text("Subtopic:")
              .font(.body)
              .foregroundColor(.secondary.opacity(0.7))
              .multilineTextAlignment(.center)
            Spacer()
          }
          let subTopicName = subTopic.title!.split(separator: " - ")
          HStack {
            Spacer()
            Text(subTopicName[0])
              .font(.body)
              .foregroundColor(.primary.opacity(0.7))
              .multilineTextAlignment(.center)
            Spacer()
          }
          if subTopicName.count > 1 {
            HStack {
              Spacer()
              Text(subTopicName[1])
                .font(.body)
                .foregroundColor(.primary.opacity(0.7))
                .multilineTextAlignment(.center)
              Spacer()
            }
          }
          Text("\n")
          HStack {
            Spacer()
            Text("Questions:" )
              .font(.title.bold())
              .foregroundColor(.secondary.opacity(0.7))
              .multilineTextAlignment(.center)
            Spacer()
          }
        }
      }
      Spacer(minLength: 40.0)
      List {
        if categoryQuestions.count > 0 {
          ForEach(categoryQuestions) { question in
            NavigationLink(question.title!,
                           value: question)
          }

          .onDelete { indexSet in
            if let index = indexSet.first {
              context.delete(categoryQuestions[index])
            }
          }
        } else {
          Text("No questions yet")
        }
      }
      .listStyle(.insetGrouped)
      .headerProminence(.increased)
      HStack {
        Spacer()
        Button("Update subtopic") {
          isUpdatePresented = true
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
        Button("Show subtopic links") {
          areSubTopicLinksVisible = true
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
        Button("Show subtopic recall timestamps") {
          areSubTopicTimeStampsVisible = true
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
      }
      .headerProminence(.increased)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          EditButton()
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isAddingQuestion = true
          } label: {
            Label("Add Question", systemImage: "plus")
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isHelpShown = true
          } label: {
            Label("Help", systemImage: "questionmark")
          }
        }
      }
      .navigationDestination(for: Question.self) { question in
        QuestionView(question: question)
      }
      .sheet(isPresented: $isAddingQuestion) {
        AddQuestionView(subTopic: subTopic)
      }
      .sheet(isPresented: $isUpdatePresented) {
        UpdateSubTopicView(isUpdatePresented: .constant(true),
                           subTopic: subTopic)
      }
      .sheet(isPresented: $areSubTopicTimeStampsVisible) {
        SubTopicTimeStampsView(areSubTopicTimeStampsVisible: .constant(true),
                               subTopic: subTopic)
      }
      .sheet(isPresented: $areSubTopicLinksVisible) {
        SubTopicLinksView(areSubTopicLinksVisible: .constant(true),
                          subTopic: subTopic)
      }
      .sheet(isPresented: $isHelpShown) {
        QuestionListViewHelpScreen()
      }
    }
    .headerProminence(.increased)
  }
}

#Preview {
  QuestionsListView(subTopic: previewSubTopic)
    .modelContainer(previewContainer)
}
