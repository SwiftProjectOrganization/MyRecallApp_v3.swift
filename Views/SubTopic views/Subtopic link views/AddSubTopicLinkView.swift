//
//  AddSubTopicLinkView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/29/24.
//

import SwiftUI
import SwiftData

struct AddSubTopicLinkView {
  @State private var title = ""
  @State private var isHelpShown: Bool = false
  @Environment(\.scenePhase) private var scenePhase
  @FocusState private var focusField
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) var context
  var subTopic: SubTopic
}

extension AddSubTopicLinkView: View {
  var body: some View {
    NavigationStack {
      HStack {
        Spacer()
        Text("Add a link for subtopic")
          .font(.title.bold())
          .foregroundStyle(.blue)
          .multilineTextAlignment(.center)
        Spacer()
      }
      VStack {
        HStack {
          Spacer()
          Text("Topic:")
            .font(.headline)
            .foregroundStyle(.secondary.opacity(0.7))
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
            .foregroundStyle(.secondary.opacity(0.7))
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
          HStack {
            TextField("Link phrase", text: $title)
              .focused($focusField)
              .multilineTextAlignment(.center)
              .padding()
              .border(Color.red,
                      width: 3)
              .font(.largeTitle)
              .onAppear {
                focusField = true
              }
          }
        }
        Spacer()
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
      .sheet(isPresented: $isHelpShown) {
        AddSubTopicLinkViewHelpScreen()
      }
    }
  }
}

extension AddSubTopicLinkView {
  func save() {
    focusField = true
    let newLink:SubTopicOnlineLink = SubTopicOnlineLink(title,
                                                        .website,
                                                        subTopic)
    subTopic.links!.append(newLink)
    dismiss()
  }
}

#Preview {
  AddSubTopicLinkView(subTopic: previewSubTopic)
    .modelContainer(previewContainer)
}
