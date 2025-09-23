//
//  UpdateTopicViewHelpScreen.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 2/10/25.
//

import SwiftUI
import SwiftData

struct UpdateTopicView: View {
  @Binding var isUpdatePresented: Bool
  @State private var isHelpShown = false
  @State private var activeInRecall = true
  @State private var theTopic = ""
  @FocusState private var focusField
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss
  var topic: Topic
}

extension UpdateTopicView {
  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Spacer()
          Text("Update topic")
            .font(.title.bold())
            .foregroundStyle(.blue)
          Spacer()
        }
      }
      Spacer()
      VStack {
        Spacer()
        HStack {
          Spacer()
          Text("Topic title:")
          Spacer()
        }
        .foregroundColor(.secondary.opacity(0.7))
        TextField("Topic", text: $theTopic, axis: .vertical)
          .focused($focusField)
          .padding()
          .multilineTextAlignment(.leading)
          .textFieldStyle(.roundedBorder)
          .border(Color.red,
                  width: 3)
          .padding()
        HStack {
          Spacer()
          Toggle("Active in recall", isOn: $activeInRecall)
            .padding(.horizontal)
          Spacer()
        }
        .textFieldStyle(.roundedBorder)
        .padding(.vertical)
        Spacer()
        HStack {
          Spacer()
          Text("Recall report:")
          Spacer()
        }
        .foregroundColor(.secondary.opacity(0.7))
        HStack {
          Text("    Last date recalled: ")
          Spacer()
          Text("\(formatDate(topic.lastRecallCycle))   ")
        }
        HStack {
          Text("    No of recalls: ")
          Spacer()
          Text("\(topic.noOfRecallCycles)   ")
        }
        Spacer()
      }
      .listStyle(.insetGrouped)
      .headerProminence(.increased)
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
      .onAppear {
        activeInRecall = topic.includedInRecall
        theTopic = topic.title!
      }
      .onDisappear {
        update()
      }
      .sheet(isPresented: $isHelpShown) {
        UpdateTopicViewHelpScreen()
      }
      HStack {
        Spacer()
        MRAButton(label: "Cancel") {
          dismiss()
        }
        Spacer()
        MRAButton(label: "Save") {
          update()
        }
        Spacer()
      }
      Spacer(minLength: 20.0)
    }
  }
}

extension UpdateTopicView {
  private func update() {
    topic.includedInRecall = activeInRecall
    if !theTopic.isEmpty {
      topic.title = theTopic
    }
    dismiss()
  }
}

#Preview {
  UpdateTopicView(isUpdatePresented: .constant(false),
                      topic: previewTopic)
  .modelContainer(previewContainer)
}

