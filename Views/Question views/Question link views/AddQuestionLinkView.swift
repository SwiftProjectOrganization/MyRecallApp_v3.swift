//
//  AddQuestionLinkView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/29/24.
//

import SwiftUI
import SwiftData

struct AddQuestionLinkView {
  @State private var title = ""
  @State private var isHelpShown: Bool = false
  @Environment(\.scenePhase) private var scenePhase
  @FocusState private var focusField
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) var context
  var question: Question
}

extension AddQuestionLinkView: View {
  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          let topic = question.subTopic!.topic!
          let subTopic = question.subTopic
          let subTopicName = subTopic!.title!.split(separator: " - ")
          VStack {
            HStack {
              Spacer()
              Text("Add question link")
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
            HStack {
              Spacer()
              Text("Question:")
                .font(.body)
                .foregroundColor(.secondary.opacity(0.7))
              Spacer()
            }
            HStack {
              Spacer()
              Text(question.title!)
                .font(.body)
                .foregroundColor(.primary.opacity(0.7))
              Spacer()
            }
          }
        }
        List {
          //VStack {
          HStack {
            TextField("Link phrase", text: $title)
              .focused($focusField)
              .multilineTextAlignment(.center)
              .font(.largeTitle)
              .padding()
              .border(Color.red,
                      width: 3)
              .font(.largeTitle)
          }
          Spacer()
        }
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            dismiss()
          } label: {
            Label("Back", systemImage: "lessthan")
          }
          .foregroundColor(.black)
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isHelpShown = true
          } label: {
            Label("Help", systemImage: "questionmark")
          }
        }
      }
      .sheet(isPresented: $isHelpShown) {
        AddQuestionLinkViewHelpScreen()
      }
      .onAppear {
        focusField = true
      }
      HStack {
        Spacer()
        MRAButton(label: "Cancel") {
          dismiss()
        }
        Spacer()
        MRAButton(label: "Save",
                  isDisabled: title.isEmpty) {
          save()
        }
        Spacer()
      }
    }
  }
}

extension AddQuestionLinkView {
  func save() {
    focusField = true
    let newLink: QuestionOnlineLink = QuestionOnlineLink(title,
                          .website,
                          question)
    question.links!.append(newLink)
    dismiss()
  }
}

#Preview {
  AddQuestionLinkView(question: previewQuestion)
    .modelContainer(previewContainer)
}
