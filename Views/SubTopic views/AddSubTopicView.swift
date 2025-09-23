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
      VStack {
        HStack {
          Spacer()
          Text("Add a subtopic")
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
          Text(topic.title!)
            .font(.body)
            .foregroundColor(.primary.opacity(0.7))
            .multilineTextAlignment(.center)
          Spacer()
        }
      }
      List {
        HStack {
          Spacer()
          TextField("Subtopic title", text: $title)
            .focused($focusField)
            .padding()
            .multilineTextAlignment(.leading)
            .textFieldStyle(.roundedBorder)
            .border(Color.red,
                    width: 3)
            .font(.largeTitle)
          Spacer()
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
      MRAButton(label: "Cancel") {
        dismiss()
      }
      Spacer()
      MRAButton(label: "Save",
                isDisabled: title.isEmpty) {
        save()
      }
      Spacer()
    }
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
