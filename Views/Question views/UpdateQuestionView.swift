//
//  UpdateQuestionView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import SwiftUI
import SwiftData

struct UpdateQuestionView {
  @Binding var isUpdateQuestionViewPresented: Bool
  @State private var activeInRecall = true
  @State private var theSubTopic = ""
  @State private var theQuestion = ""
  @State private var answer = ""
  @State private var isHelpShown: Bool = false
  @Environment(\.modelContext) private var context
  @Query var questionRecallTimeStamps: [QuestionRecallTimeStamp]
  @Environment(\.dismiss) private var dismiss
  var question: Question
}

extension UpdateQuestionView {
  private var recallTimeStamps: [QuestionRecallTimeStamp] {
    questionRecallTimeStamps.filter { $0.question == question}.sorted { $0.date! < $1.date! }
  }
}

extension UpdateQuestionView: View {
  var body: some View {
    NavigationStack {
      HStack {
        Spacer()
        Text("Update a question:")
          .font(.title.bold())
          .foregroundColor(.primary.opacity(0.7))
          .multilineTextAlignment(.center)
        Spacer()
      }
      Spacer(minLength: 40.0)
      List {
        VStack {
          HStack {
            Spacer()
            Text("Subtopic:\n")
              .font(.headline)
            Spacer()
          }
          HStack {
            Spacer()
            Text(question.subTopic!.title!)
              .font(.headline)
            Spacer()
          }
          .padding(.bottom)
          Spacer()
          HStack {
            Spacer()
            Text("Question:")
              .font(.headline)
              .foregroundColor(.secondary.opacity(0.7))
            Spacer()
          }
          HStack {
            Spacer()
            TextField("Question", text: $theQuestion, axis: .vertical)
              .textFieldStyle(.roundedBorder)
              .border(Color.red,
                      width: 3)
              .padding()
            Spacer()
          }
          Spacer()
          HStack {
            Spacer()
            Text("Answer:\n")
              .font(.headline)
              .foregroundColor(.secondary.opacity(0.7))
              .padding()
            Spacer()
          }
          HStack {
            Spacer()
            TextField("Answer", text: $answer, axis: .vertical)
              .textFieldStyle(.roundedBorder)
              .border(Color.red,
                      width: 3)
              .padding()
            Spacer()
          }
          .listStyle(.insetGrouped)
          Spacer(minLength: 20.0)
          Section(header: Text("Report:\n")) {
            HStack {
              Text("    Last date recalled: ")
              Spacer()
              Text("\(formatDate(question.lastRecallCycle))   ")
            }
            .foregroundStyle(.black)
            HStack {
              Text("    No of recalls: ")
              Spacer()
              Text("\(question.noOfRecallCycles)   ")
            }
            .foregroundStyle(.black)
          }
          .listStyle(.insetGrouped)
          HStack {
            Toggle("    Active in recall", isOn: $activeInRecall)
          }
        }
        .onAppear {
          activeInRecall = question.includedInRecall
          theSubTopic = question.subTopic!.title!
          theQuestion = question.title!
          if question.answer != "" {
            answer = question.answer
          }
        }
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              dismiss()
            } label: {
              Label("Back", systemImage: "lessthan")
            }
          }
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              isHelpShown = true
            } label: {
              Label("Help", systemImage: "questionmark")
            }
          }
        }
      }
      .sheet(isPresented: $isHelpShown) {
        UpdateQuestionViewHelpScreen()
      }
      Spacer()
      HStack {
        Spacer()
        Button("Cancel") {
          dismiss()
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
        Button("Save") {
          save()
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
      }
      Spacer(minLength: 20.0)
      .headerProminence(.increased)
    }
    .foregroundColor(.primary.opacity(0.7))
  }
}

extension UpdateQuestionView {
  private func save() {
    question.includedInRecall = activeInRecall
    if !theSubTopic.isEmpty && theQuestion != question.subTopic!.title! {
      question.subTopic!.title! = theSubTopic
    }
    if !theQuestion.isEmpty && theQuestion != question.title! {
      question.title! = theQuestion
    }
    if !answer.isEmpty && answer != question.answer {
      question.answer = answer
      if !question.timeStamps!.isEmpty && question.timeStamps!.count < 10 {
        question.timeStamps?.append(QuestionRecallTimeStamp(date: Date()))
      }
    }
    dismiss()
  }
}

#Preview {
  UpdateQuestionView( isUpdateQuestionViewPresented: .constant(false),
                                question: previewQuestion)
  .modelContainer(previewContainer)
}
