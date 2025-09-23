//
//  UpdateQuestionView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import SwiftUI
import SwiftData

@MainActor
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
      VStack {
        HStack {
          Spacer()
          Text("Update a question")
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
          Text(question.subTopic!.topic!.title!)
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
        let subTopicName = question.subTopic!.title!.split(separator: " - ")
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
      Spacer()
      VStack {
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
            .padding()
            .multilineTextAlignment(.leading)
            .textFieldStyle(.roundedBorder)
            .border(Color.red,
                    width: 3)
            .padding()
          Spacer()
        }
        HStack {
          Spacer()
          Text("Answer:\n")
            .font(.headline)
            .foregroundColor(.secondary.opacity(0.7))
          Spacer()
        }
        HStack {
          Spacer()
          TextField("Answer", text: $answer, axis: .vertical)
            .padding()
            .multilineTextAlignment(.leading)
            .textFieldStyle(.roundedBorder)
            .border(Color.red,
                    width: 3)
            .padding(.horizontal)
          Spacer()
        }
        .listStyle(.insetGrouped)
        HStack {
          Toggle("    Active in recall", isOn: $activeInRecall)
            .padding(.horizontal)
        }
        VStack {
          Spacer()
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
          //.listStyle(.insetGrouped)
          Spacer()
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
        MRAButton(label: "Cancel") {
          dismiss()
        }
        Spacer()
        MRAButton(label: "Save") {
          save()
        }
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
