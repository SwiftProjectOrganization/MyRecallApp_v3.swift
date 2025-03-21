//
//  IndividualQuestionView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import SwiftUI
import SwiftData

struct QuestionAndUserAnswerView {
  @AppStorage(wrappedValue: "10", .settingsTimeStampsKey)
  private var noOfTimeStampsString: String

  @Binding var isRecallOn: Bool
  @Binding var questions: [Question]
  @Binding var filteredQuestions: [Question]
  @Binding var selectedQuestion: Question?
  @Binding var showAnswer: Bool
  @State private var userAnswer: String = ""
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss
}

extension QuestionAndUserAnswerView: View {
  var body: some View {
    NavigationStack {
      VStack {
        if !showAnswer {
          Text("Recall question and user answer view")
            .font(.headline)
            .foregroundStyle(.secondary)
          Text("Topic: \(selectedQuestion!.subTopic!.topic!.title!)")
            .foregroundStyle(.secondary)
          Text("Subtopic: \(selectedQuestion!.subTopic!.title!)")
            .foregroundStyle(.secondary)
        }
        Text("\n")
        Text("Question: \(String(describing: selectedQuestion!.title!))")
          .foregroundStyle(.primary)
        TextField("User answer", text: $userAnswer, axis: .vertical)
          .padding()
          .multilineTextAlignment(.leading)
          .textFieldStyle(.roundedBorder)
          .border(Color.red,
                  width: 3)
          .padding()
        if showAnswer {
          VStack {
            Text(LocalizedStringResource(stringLiteral: selectedQuestion!.answer))
              .padding()
              .multilineTextAlignment(.leading)
              .textFieldStyle(.roundedBorder)
              .border(Color.blue,
                      width: 3)
              .padding()
          }
        }
        Spacer()
        VStack {
          if !showAnswer {
            Text("Questions left:: \(filteredQuestions.count) of \(questions.count)")
          }
          HStack {
            Spacer()
            Button("Cancel") {
              isRecallOn = false
              dismiss()
            }
            .buttonBorderShape(.roundedRectangle)
            .buttonStyle(.borderedProminent)
            Spacer()
            Button("Show answer") {
              showAnswer = true
            }
            .disabled(filteredQuestions.count == 1)
            .buttonBorderShape(.roundedRectangle)
            .buttonStyle(.borderedProminent)

            Spacer()
            Button("Next question") {
              showAnswer = false
              userAnswer = ""
              updateTimeStamps(selectedQuestion!, Int(noOfTimeStampsString) ?? 10)
              selectedQuestion! = nextQuestion()
            }
            .disabled(filteredQuestions.count == 1)
            .buttonBorderShape(.roundedRectangle)
            .buttonStyle(.borderedProminent)

            Spacer()
          }
          .padding()
        }
      }
      .onAppear() {
        userAnswer = ""
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            isRecallOn = false
            dismiss()
          } label: {
            Label("Back", systemImage: "lessthan")
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            //isHelpShown = true
          } label: {
            Label("Help", systemImage: "questionmark")
          }
        }
      }
    }
  }
}

extension QuestionAndUserAnswerView {
  func nextQuestion() -> Question {
    if filteredQuestions.count > 1 {
      if filteredQuestions.contains(selectedQuestion!) {
        filteredQuestions.removeAll { $0 == selectedQuestion }
      }
    }
    let index = Int.random(in: 0..<filteredQuestions.count)
    selectedQuestion! = filteredQuestions[index]
    return filteredQuestions[index]
  }
}

extension QuestionAndUserAnswerView {
  func updateTimeStamps(_ question: Question,
                        _ noOfTimeStamps: Int = 10) {
    question.lastRecallCycle = Date()
    question.noOfRecallCycles += 1
    let questionRecallTimeStamp = QuestionRecallTimeStamp()
    questionRecallTimeStamp.question = selectedQuestion
    if selectedQuestion!.timeStamps == nil {
      selectedQuestion!.timeStamps = [questionRecallTimeStamp]
    } else {
      if selectedQuestion!.timeStamps!.count > noOfTimeStamps {
        selectedQuestion!.timeStamps!.remove(at: 0)
      }
      selectedQuestion!.timeStamps!.append(questionRecallTimeStamp)
    }
    question.subTopic!.lastRecallCycle = Date()
    question.subTopic!.noOfRecallCycles += 1
    let subTopicRecallTimeStamp = SubTopicRecallTimeStamp()
    subTopicRecallTimeStamp.subTopic = selectedQuestion!.subTopic
    if selectedQuestion!.timeStamps == nil {
      selectedQuestion!.subTopic!.timeStamps = [subTopicRecallTimeStamp]
    } else {
      if selectedQuestion!.subTopic!.timeStamps!.count > noOfTimeStamps {
        selectedQuestion!.subTopic!.timeStamps!.remove(at: 0)
      }
      selectedQuestion!.subTopic!.timeStamps!.append(subTopicRecallTimeStamp)
    }
    question.subTopic!.topic!.lastRecallCycle = Date()
    question.subTopic!.topic!.noOfRecallCycles += 1
    let topicRecallTimeStamp = TopicRecallTimeStamp()
    topicRecallTimeStamp.topic = selectedQuestion!.subTopic!.topic
    if selectedQuestion!.timeStamps == nil {
      selectedQuestion!.subTopic!.topic!.timeStamps = [topicRecallTimeStamp]
    } else {
      if selectedQuestion!.subTopic!.topic!.timeStamps!.count > noOfTimeStamps {
        selectedQuestion!.subTopic!.topic!.timeStamps!.remove(at: 0)
      }
      selectedQuestion!.subTopic!.topic!.timeStamps!.append(topicRecallTimeStamp)
    }
  }
}

extension QuestionAndUserAnswerView {
  func shrinkNoOfSubTopicTimeStamps(_ timestamps: [SubTopicRecallTimeStamp]) -> [SubTopicRecallTimeStamp] {
    return timestamps
  }
}

extension QuestionAndUserAnswerView {
  func shrinkNoOfTopicTimeStamps(_ timestamps: [TopicRecallTimeStamp]) -> [TopicRecallTimeStamp] {
    return timestamps
  }
}

#Preview {
  QuestionAndUserAnswerView(isRecallOn: .constant(true),
                            questions: .constant([previewQuestion]),
                            filteredQuestions: .constant([previewQuestion]),
                            selectedQuestion: .constant(previewQuestion),
                            showAnswer: .constant(false))
  .modelContainer(previewContainer)
}
