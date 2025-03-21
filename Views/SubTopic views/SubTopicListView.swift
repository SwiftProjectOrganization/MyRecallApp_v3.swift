//
//  SubTopicListView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/4/25.
//

import SwiftUI
import SwiftData

struct SubTopicListView {
  //@State private var path = NavigationPath()
  @State private var isAddingSubTopic: Bool = false
  @State private var isHelpShown: Bool = false
  @State private var isUpdatePresented = false
  @State private var areTopicsTimeStampsVisible = false
  @State private var areTopicsLinksVisible = false

  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss
  @Query private var subTopics: [SubTopic]
  var topic: Topic
}

extension SubTopicListView {
  private var topicSubTopics: [SubTopic] {
    subTopics.filter { $0.topic == topic}.sorted { $0.title! < $1.title! }
  }
}

extension SubTopicListView: View {
  var body: some View {
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
        Text(topic.title!)
          .font(.body)
          .foregroundColor(.primary.opacity(0.7))
          .multilineTextAlignment(.center)
        Spacer()
      }
      Text("\n")
      HStack {
        Spacer()
        Text("Subtopic list:")
          .font(.title.bold())
          .foregroundColor(.secondary.opacity(0.7))
        Spacer()
      }
      Spacer(minLength: 40.0)
      List {
        if topicSubTopics.count > 0 {
          ForEach(topicSubTopics) { subTopic in
            NavigationLink(subTopic.title!,
                           value: subTopic)
          }
          .onDelete { indexSet in
            if let index = indexSet.first {
              context.delete(topicSubTopics[index])
            }
          }
        } else {
          Text("No subtopics found.")
        }
      }
      .listStyle(.insetGrouped)
      .headerProminence(.increased)
      HStack {
        Spacer()
        Button("Update topic") {
          isUpdatePresented = true
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
            isAddingSubTopic = true
          } label: {
            Label("Add subtopic", systemImage: "plus")
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
      .navigationDestination(for: SubTopic.self) { subTopic in
        QuestionsListView(subTopic: subTopic)
      }
      .sheet(isPresented: $isAddingSubTopic) {
        AddSubTopicView(topic: topic)
      }
      .sheet(isPresented: $isHelpShown) {
        SubTopicListViewHelpScreen()
      }
      .sheet(isPresented: $isUpdatePresented) {
        UpdateTopicView(isUpdatePresented: $isUpdatePresented,
                           topic: topic)
      }
    }
    .headerProminence(.increased)
  }
}

#Preview {
  SubTopicListView(topic: previewTopic)
    .modelContainer(previewContainer)
}
