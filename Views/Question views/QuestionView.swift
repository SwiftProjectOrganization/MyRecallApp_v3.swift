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
        Spacer()
        Text("Question from subtopic: `\(String(describing: question.subTopic!.title!))`")
          .font(.title.bold())
          .multilineTextAlignment(.center)
        Spacer()
      }
      .padding(.vertical, 40.0)
      List {
        VStack {
          HStack {
            Spacer()
            Text("Question:")
              .foregroundColor(.secondary.opacity(0.7))
            Spacer()
          }
          Spacer()
          Text(question.title!)
          Spacer()
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
      .listStyle(GroupedListStyle())
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
        Button("Update\nquestion") {
          isUpdateQuestionViewPresented = true
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
        Button("Show question \nlinks") {
          areQuestionLinksVisible = true
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
        Button("Show question\nrecall timestamps") {
          areQuestionTimeStampsVisible = true
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
      }
    }
    .sheet(isPresented: $isUpdateQuestionViewPresented) {
      UpdateQuestionView(isUpdateQuestionViewPresented: .constant(true),
                         question: question)
    }
    .sheet(isPresented: $areQuestionLinksVisible) {
      ShowQuestionLinksView(areQuestionLinksVisible: .constant(true),
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
