//
//  SubTopicTimeStampsView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import SwiftUI
import SwiftData

struct SubTopicTimeStampsView {
  @State private var isHelpShown: Bool = false
  @Binding var areSubTopicTimeStampsVisible: Bool
  @Environment(\.modelContext) private var context
  @Query var categoryRecallTimeStamps: [SubTopicRecallTimeStamp]
  @Environment(\.dismiss) private var dismiss
  var subTopic: SubTopic
}

extension SubTopicTimeStampsView {
  private var recallTimeStamps: [SubTopicRecallTimeStamp] {
    categoryRecallTimeStamps.filter { $0.subTopic == subTopic}.sorted { $0.date! < $1.date! }
  }
}

extension SubTopicTimeStampsView: View {
  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Spacer()
          Text("Subtopic time stamps:")
            .font(.title.bold())
            .foregroundColor(.primary.opacity(0.7))
          Spacer()
        }
        List {
          VStack {
            Spacer()
            HStack {
              Spacer()
              Text("Subtopic:")
                .font(.headline)
                .foregroundColor(.secondary.opacity(0.7))
              Spacer()
            }
            Spacer()
            HStack {
              Spacer()
              Text(subTopic.title!)
              Spacer()
            }
            Spacer()
            HStack {
              Spacer()
              Text("Time Stamps:")
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
      }
      .headerProminence(.increased)
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
      HStack {
        Spacer()
        Button("Done") {
          areSubTopicTimeStampsVisible = false
          done()
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
      }
      Spacer(minLength: 20.0)
    }
    .headerProminence(.increased)
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
