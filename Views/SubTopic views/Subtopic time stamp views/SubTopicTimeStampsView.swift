//
//  SubTopicTimeStampsView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import SwiftUI
import SwiftData

@MainActor
struct SubTopicTimeStampsView {
  @State private var isHelpShown: Bool = false
  @Binding var areSubTopicTimeStampsVisible: Bool
  @Environment(\.modelContext) private var context
  @Query var subTopicRecallTimeStamps: [SubTopicRecallTimeStamp]
  @Environment(\.dismiss) private var dismiss
  var subTopic: SubTopic
}

extension SubTopicTimeStampsView {
  private var recallTimeStamps: [SubTopicRecallTimeStamp] {
    subTopicRecallTimeStamps.filter { $0.subTopic == subTopic}.sorted { $0.date! < $1.date! }
  }
}

extension SubTopicTimeStampsView: View {
  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Spacer()
          Text("Subtopic recall\ntimestamps")
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
          Text(subTopic.topic!.title!)
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
          Text(subTopic.title!)
          Spacer()
        }
      }
      Spacer()
      List {
        VStack {
          //Spacer()
          HStack {
            Spacer()
            Text("Timestamps:")
              .font(.headline)
              .foregroundColor(.secondary.opacity(0.7))
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
          Spacer()
        }
      }
      HStack {
        Spacer()
        MRAButton(label: "Done") {
          areSubTopicTimeStampsVisible = false
          done()
        }
        Spacer()
      }
      Spacer()
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
    }
    .sheet(isPresented: $isHelpShown) {
      SubTopicTimeStampsViewHelpScreen()
    }
  }
}

extension SubTopicTimeStampsView {
  private func done() {
    dismiss()
  }
}

#Preview {
  SubTopicTimeStampsView(areSubTopicTimeStampsVisible: .constant(true),
                         subTopic: previewSubTopic)
  .modelContainer(previewContainer)
}
