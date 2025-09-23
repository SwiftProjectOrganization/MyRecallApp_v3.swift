//
//  QuestionView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import SwiftUI
import SwiftData

struct QuestionView {
  @State private var isUpdateQuestionViewPresented: Bool = false
  @State private var areQuestionTimeStampsVisible: Bool = false
  @State private var areQuestionLinksVisible: Bool = false
  @State private var isHelpShown: Bool = false
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss
  var question: Question
}

extension QuestionView: View {
  var body: some View {
    VStack {
      HStack {
        let topic = question.subTopic!.topic!
        let subTopic = question.subTopic
        let subTopicName = subTopic!.title!.split(separator: " - ")
        VStack {
          HStack {
            Spacer()
            Text("Question view")
              .font(.title.bold())
              .foregroundStyle(Color(.systemBlue))
            Spacer()
          }
          HStack {
            Spacer()
            Text("Topic:")
              .font(.body)
              .foregroundColor(.secondary.opacity(0.7))
            Spacer()
          }
          HStack {
            Spacer()
            Text(topic.title!)
              .font(.body)
              .foregroundColor(.primary.opacity(0.7))
            Spacer()
          }
          HStack {
            Spacer()
            Text("Subtopic:")
              .font(.body)
              .foregroundColor(.secondary.opacity(0.7))
            Spacer()
          }
          HStack {
            Spacer()
            Text(subTopicName[0])
              .font(.body)
              .foregroundColor(.primary.opacity(0.7))
             Spacer()
          }
          if subTopicName.count > 1 {
            HStack {
              Spacer()
              Text(subTopicName[1])
                .font(.body)
                .foregroundColor(.primary.opacity(0.7))
              Spacer()
            }
          }
        }
      }
      .padding()
      VStack {
        VStack {
          HStack {
            Spacer()
            Text("Question:")
              .foregroundColor(.secondary.opacity(0.7))
            Spacer()
          }
          Text(question.title!)
            .padding(.vertical, 10.0)
          HStack {
            Spacer()
            Text("Answer:")
              .foregroundColor(.secondary.opacity(0.7))
            Spacer()
          }
        }
        .padding()
        Text(LocalizedStringResource(stringLiteral: question.answer))
          .padding()
        Spacer()
      }
      .padding()
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isHelpShown = true
          } label: {
            Label("Help", systemImage: "questionmark")
          }
        }
      }
      HStack {
        Spacer()
        MRAButton(label: "Update question") {
          isUpdateQuestionViewPresented = true
        }
        Spacer()
        MRAButton(label: "Question links") {
          areQuestionLinksVisible = true
        }
        Spacer()
        MRAButton(label: "Question recalls") {
          areQuestionTimeStampsVisible = true
        }
        Spacer()
      }
    }
    .sheet(isPresented: $isUpdateQuestionViewPresented) {
      UpdateQuestionView(isUpdateQuestionViewPresented: .constant(true),
                         question: question)
    }
    .sheet(isPresented: $areQuestionLinksVisible) {
      QuestionLinksView(areQuestionLinksVisible: .constant(true),
                        question: question)
    }
    .sheet(isPresented: $areQuestionTimeStampsVisible) {
      QuestionTimeStampsView(areQuestionTimeStampsVisible: .constant(true),
                             question: question)
    }
    .sheet(isPresented: $isHelpShown) {
      QuestionViewHelpScreen()
    }
  }
}

#Preview {
  QuestionView(question: previewQuestion)
    .modelContainer(previewContainer)
}
