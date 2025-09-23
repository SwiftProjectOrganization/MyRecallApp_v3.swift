//
//  AddQuestionView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import SwiftUI

struct AddQuestionView {
  @State private var title = ""
  @State private var answer = ""
  @State private var isHelpShown = false
  @Environment(\.scenePhase) private var scenePhase
  @FocusState private var focusField
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) var context
  var subTopic: SubTopic
}

extension AddQuestionView: View {
  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Spacer()
          Text("Add a question")
            .font(.title.bold())
            .foregroundStyle(.blue)
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
          Text(subTopic.topic!.title!)
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
        let subTopicName = subTopic.title!.split(separator: " - ")
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
      .padding(.vertical, 40.0)
      List {
        VStack {
          HStack {
            Spacer()
            TextField("Question title", text: $title)
              .focused($focusField)
              .font(.title)
              .padding()
              .multilineTextAlignment(.leading)
              .textFieldStyle(.roundedBorder)
              .border(Color.red,
                      width: 3)
             Spacer()
          }
          .onAppear {
            focusField = true
            title = ""
          }
          .onSubmit {
            if !(title == "") {
              save()
            }
          }
          Spacer()
          TextField("Answer", text: $answer, axis: .vertical)
            .padding()
            .multilineTextAlignment(.leading)
            .textFieldStyle(.roundedBorder)
            .border(Color.red,
                    width: 3)
            .padding()
        }
      }
      .onAppear {
        focusField = true
      }
      .onSubmit {
        save()
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            dismiss()
          } label: {
            Label("Back", systemImage: "lessthan")
          }
          .foregroundColor(.black)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            isHelpShown = true
          } label: {
            Label("Help", systemImage: "questionmark")
          }
          .foregroundColor(.black)
        }
      }
      Spacer()
        .sheet(isPresented: $isHelpShown) {
          AddQuestionViewHelpScreen()
        }
      HStack {
        Spacer()
        MRAButton(label: "Cancel") {
          dismiss()
        }
        Spacer()
        MRAButton(label: "Save",
                  isDisabled: title.isEmpty || answer.isEmpty) {
          save()
        }
        Spacer()
      }
      Spacer(minLength: 20.0)
    }
  }
}

extension AddQuestionView {
  func save() {
    focusField = false
    let newQuestion = Question(title)
    newQuestion.answer = answer
    newQuestion.subTopic = subTopic
    context.insert(newQuestion)
    dismiss()
  }
}

#Preview {
  AddQuestionView(subTopic: previewSubTopic)
    .modelContainer(previewContainer)
}
