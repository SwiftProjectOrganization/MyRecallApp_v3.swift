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
      HStack {
        Spacer()
        Text("Add a Question to:\n`\(String(describing: subTopic.title!))`:")
          .font(.title.bold())
          .foregroundColor(.primary.opacity(0.7))
          .multilineTextAlignment(.center)
        Spacer()
      }
      .padding(.vertical, 40.0)
      List {
        VStack {
          HStack {
            TextField("Question title", text: $title)
              .focused($focusField)
              .multilineTextAlignment(.center)
              .font(.largeTitle)
              .padding()
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
            .textFieldStyle(.roundedBorder)
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
        Button("Cancel") {
          dismiss()
        }
        Spacer()
        Button("Save") {
          save()
        }
        .disabled(title.isEmpty || answer.isEmpty)
        Spacer()
      }
      .foregroundStyle(.black)
      .buttonBorderShape(.roundedRectangle)
      .buttonStyle(.borderedProminent)
      .multilineTextAlignment(.center)
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
