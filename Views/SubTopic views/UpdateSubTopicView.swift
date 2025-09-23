//
//  UpdateSubTopicView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import SwiftUI
import SwiftData

struct UpdateSubTopicView {
  @Binding var isUpdatePresented: Bool
  @State private var isHelpShown = false
  @State private var activeInRecall = true
  @State private var theSubTopic = ""
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss
  var subTopic: SubTopic
}

extension UpdateSubTopicView: View {
  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Spacer()
          Text("Update subtopic")
            .font(.title.bold())
            .foregroundStyle(.blue)
          Spacer()
        }
        HStack {
          Spacer()
          Text("Topic:")
            .font(.body)
            .foregroundColor(.secondary.opacity(0.7))
            .multilineTextAlignment(.center)
          Spacer()
        }
        HStack {
          Spacer()
          Text(subTopic.topic!.title!)
            .font(.body)
            .foregroundColor(.primary.opacity(0.7))
            .multilineTextAlignment(.center)
          Spacer()
        }
      }
      VStack {
        Spacer()
        HStack {
          Spacer()
          Text("Subtopic title:")
          Spacer()
        }
        .foregroundColor(.secondary.opacity(0.7))
        TextField("Subtopic", text: $theSubTopic, axis: .vertical)
          .textFieldStyle(.roundedBorder)
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
        Spacer()
        HStack {
          Spacer()
          Text("Report:")
          Spacer()
        }
        .foregroundColor(.secondary.opacity(0.7))
        HStack {
          Text("    Last date recalled: ")
          Spacer()
          Text("\(formatDate(subTopic.lastRecallCycle))   ")
        }
        HStack {
          Text("    No of recalls: ")
          Spacer()
          Text("\(subTopic.noOfRecallCycles)   ")
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
        activeInRecall = subTopic.includedInRecall
        theSubTopic = subTopic.title!
      }
      .onDisappear {
        update()
      }
      .sheet(isPresented: $isHelpShown) {
        UpdateSubTopicViewHelpScreen()
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

extension UpdateSubTopicView {
  private func update() {
    subTopic.includedInRecall = activeInRecall
    if !theSubTopic.isEmpty {
      subTopic.title = theSubTopic
    }
    dismiss()
  }
}

#Preview {
  UpdateSubTopicView(isUpdatePresented: .constant(false),
                      subTopic: previewSubTopic)
  .modelContainer(previewContainer)
}
