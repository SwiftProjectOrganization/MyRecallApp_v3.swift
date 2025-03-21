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
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss
  var topic: Topic
}

extension UpdateTopicView {
  var body: some View {
    NavigationStack {
      HStack {
        Spacer()
        Text("Update topic:")
          .font(.title.bold())
          .foregroundColor(.primary.opacity(0.7))
        Spacer()
      }
      List {
        HStack {
          Spacer()
          Text("Topic title:")
          Spacer()
        }
        .foregroundColor(.secondary.opacity(0.7))
        TextField("Topic", text: $theTopic, axis: .vertical)
          .textFieldStyle(.roundedBorder)
          .border(Color.red,
                  width: 3)
          .padding()
        HStack {
          Spacer()
          Text("Report:")
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
        HStack {
          Spacer()
          Toggle("Active in recall", isOn: $activeInRecall)
          Spacer()
        }
        .textFieldStyle(.roundedBorder)
        .border(Color.red,
                width: 3)
        .padding(.vertical)
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
        Button("Cancel") {
          dismiss()
        }
        .foregroundStyle(.black)
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        
        Spacer()
        Button("Save") {
          update()
        }
        .foregroundStyle(.black)
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
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

