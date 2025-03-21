//
//  UpdateQuestionView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import SwiftUI
import SwiftData

struct UpdateIndividualQuestionView {
  @Binding var isUpdateIndividualQuestionViewPresented: Bool
  @State private var activeInRecall = true
  @State private var theCategory = ""
  @State private var theQuestion = ""
  @State private var answer = ""
  @State private var isHelpShown: Bool = false
  @Environment(\.modelContext) private var context
  @Query var questionRecallTimeStamps: [QuestionRecallTimeStamp]
  @Environment(\.dismiss) private var dismiss
  var question: Question
}

extension UpdateIndividualQuestionView {
  private var recallTimeStamps: [QuestionRecallTimeStamp] {
    questionRecallTimeStamps.filter { $0.question == question}.sorted { $0.date! < $1.date! }
  }
}

extension UpdateIndividualQuestionView: View {
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Spacer()
            Text("Category:\n")
              .font(.headline)
              .foregroundStyle(.blue)
            Spacer()
          }
          HStack {
            Spacer()
            Text(question.category!.title!)
              .font(.headline)
              .foregroundStyle(.black)
            Spacer()
          }
          .padding(.bottom)
          Spacer()
          HStack {
            Spacer()
            Text("Question:")
              .font(.headline)
              .foregroundStyle(.blue)
            Spacer()
          }
          HStack {
            Spacer()
            TextField("Question", text: $theQuestion, axis: .vertical)
              .textFieldStyle(.roundedBorder)
              .border(Color.red,
                      width: 3)
              .foregroundColor(.black)
              .padding()
            Spacer()
          }
          Spacer()
          HStack {
            Spacer()
            Text("Answer:\n")
              .font(.headline)
              .foregroundStyle(.blue)
            Spacer()
          }
          HStack {
            Spacer()
            TextField("Answer", text: $answer, axis: .vertical)
              .textFieldStyle(.roundedBorder)
              .foregroundStyle(.black)
              .border(Color.red,
                      width: 3)
            Spacer()
          }
          .listStyle(.insetGrouped)
          .foregroundStyle(.blue)
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
          .foregroundStyle(.blue)
          HStack {
            Toggle("    Active in recall", isOn: $activeInRecall)
          }
        }
        .foregroundStyle(.black)
        .onAppear {
          activeInRecall = question.includedInRecall
          theCategory = question.category!.title!
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
      }
      .sheet(isPresented: $isHelpShown) {
        AddQuestionViewHelpScreen()
      }
      Spacer()
      Section(header: Text("Controls:")) {
        HStack {
          Spacer()
          Button("Cancel") {
            dismiss()
          }
          .foregroundStyle(.black)
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
          .multilineTextAlignment(.center)
          
          Spacer()
          Button("Save") {
            save()
          }
          .foregroundStyle(.black)
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
          .multilineTextAlignment(.center)
          Spacer()
        }
        Spacer(minLength: 20.0)
      }
      .foregroundStyle(.blue)
      .headerProminence(.increased)
      .foregroundStyle(.blue)
    }
  }
}

extension UpdateIndividualQuestionView {
  private func save() {
    question.includedInRecall = activeInRecall
    if !theCategory.isEmpty && theQuestion != question.category!.title! {
      question.category!.title! = theCategory
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
  UpdateIndividualQuestionView( isUpdateIndividualQuestionViewPresented: .constant(false),
                                question: previewQuestion)
  .modelContainer(previewContainer)
}
