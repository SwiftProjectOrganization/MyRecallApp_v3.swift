//
//  QuestionTimeStampsView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import SwiftUI
import SwiftData

@MainActor
struct QuestionTimeStampsView {
  @State private var isHelpShown: Bool = false
  @Binding var areQuestionTimeStampsVisible: Bool
  @Environment(\.modelContext) private var context
  @Query var questionRecallTimeStamps: [QuestionRecallTimeStamp]
  @Environment(\.dismiss) private var dismiss
  var question: Question
}

extension QuestionTimeStampsView {
  private var recallTimeStamps: [QuestionRecallTimeStamp] {
    questionRecallTimeStamps.filter { $0.question == question}.sorted { $0.date! < $1.date! }
  }
}

extension QuestionTimeStampsView: View {
  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Spacer()
          Text("Question timestamps:")
            .font(.title.bold())
            .foregroundStyle(.blue)
            .multilineTextAlignment(.center)
          Spacer()
        }
        HStack {
          Spacer()
          Text("Topic:")
            .font(.headline)
            .foregroundColor(.secondary.opacity(0.7))
          Spacer()
        }
        HStack {
          Spacer()
          Text(question.subTopic!.topic!.title!)
            .foregroundColor(.black)
          Spacer()
        }
        HStack {
          Spacer()
          Text("Subtopic:")
            .font(.headline)
            .foregroundColor(.secondary.opacity(0.7))
          Spacer()
        }
        HStack {
          Spacer()
          Text(question.subTopic!.title!)
            .foregroundColor(.black)
          Spacer()
        }
        HStack {
          Spacer()
          Text("Question:")
            .font(.headline)
            .foregroundStyle(.secondary.opacity(0.7))
          Spacer()
        }
        HStack {
          Spacer()
          Text(question.title!)
          Spacer()
        }
        Spacer()
        List {
          VStack {
            HStack {
              Spacer()
              Text("Timestamps:")
                .font(.headline)
                .foregroundStyle(.secondary.opacity(0.7))
              Spacer()
            }
            if recallTimeStamps.count > 0 {
              ForEach(recallTimeStamps) { timeStamp in
                Text(formatDate(timeStamp.date!))
                  .textFieldStyle(.roundedBorder)
              }
            } else {
              Text("No recall time stamps yet!")
                .padding()
            }
          }
          Spacer()
        }
        HStack {
          Spacer()
          MRAButton(label: "Done") {
            areQuestionTimeStampsVisible = false
            done()
          }
          Spacer()
        }
      }
//     .navigationDestination(for: QuestionRecallTimeStamp.self) { timestamp in
//
//     }
      Spacer()
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button {
              dismiss()
            } label: {
              Label("Back", systemImage: "lessthan")
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
        .sheet(isPresented: $isHelpShown) {
          QuestionTimeStampsViewHelpScreen()
        }
    }
  }
}

extension QuestionTimeStampsView {
  private func done() {
    dismiss()
  }
}

#Preview {
  QuestionTimeStampsView(areQuestionTimeStampsVisible: .constant(false),
                         question: previewQuestion)
  .modelContainer(previewContainer)
}
