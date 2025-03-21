//
//  AddSubTopicView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/29/24.
//

import SwiftUI
import SwiftData

struct AddSubTopicView {
  @State private var title = ""
  @State private var isHelpShown: Bool = false
  @Environment(\.scenePhase) private var scenePhase
  @FocusState private var focusField
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) var context
  var topic: Topic
}

extension AddSubTopicView: View {
  var body: some View {
    NavigationStack {
      HStack {
        Spacer()
        Text("Add subtopic:")
          .font(.title.bold())
          .foregroundColor(.primary.opacity(0.7))
        Spacer()
      }
      .padding(.vertical, 40.0)
      List {
        HStack {
          TextField("Subtopic title", text: $title)
            .focused($focusField)
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .padding()
        }
        .onAppear {
          focusField = true
          title = ""
        }
        .onSubmit {
          if !(title == "") {
            save()
          }
        }
        Spacer()
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
      AddSubTopicViewHelpScreen()
    }
    HStack {
      Spacer()
      Button("Cancel",
             role: .cancel) {
        dismiss()
      }
      .buttonStyle(.borderedProminent)
      Spacer()
      Button("Save",
             action: save)
      .disabled(title.isEmpty)
      .buttonStyle(.borderedProminent)
      Spacer()
    }
    .foregroundStyle(.black)
    Spacer(minLength: 20.0)
    .headerProminence(.increased)
    .foregroundStyle(.blue)
  }
}

extension AddSubTopicView {
  func save() {
    focusField = false
    context.insert(SubTopic(title, topic))
    dismiss()
  }
}

#Preview {
  AddSubTopicView(topic: previewTopic)
    .modelContainer(previewContainer)
}
