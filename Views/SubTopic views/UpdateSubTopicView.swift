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
      HStack {
        Spacer()
        Text("Update subtopic:")
          .font(.title.bold())
          .foregroundColor(.primary.opacity(0.7))
        Spacer()
      }
      List {
        HStack {
          Spacer()
          Text("Subtopic title:")
          Spacer()
        }
        .foregroundColor(.secondary.opacity(0.7))
        TextField("Subtopic", text: $theSubTopic, axis: .vertical)
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
          Text("\(formatDate(subTopic.lastRecallCycle))   ")
        }
        HStack {
          Text("    No of recalls: ")
          Spacer()
          Text("\(subTopic.noOfRecallCycles)   ")
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
