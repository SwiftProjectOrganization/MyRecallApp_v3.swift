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
        Text("Add a link for subtopic:\n\(subTopic.title!)")
          .font(.title.bold())
          .foregroundColor(.primary.opacity(0.7))
          .multilineTextAlignment(.center)
        Spacer()
      }
      Spacer(minLength: 40.0)
      List {
        VStack {
          HStack {
            TextField("Link phrase", text: $title)
              .focused($focusField)
              .multilineTextAlignment(.center)
              .font(.largeTitle)
              .padding()
          }
          Spacer()
          .onAppear {
            focusField = true
          }
        }
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
      HStack {
        Spacer()
        Button("Cancel",
               role: .cancel) {
          dismiss()
        }
               .foregroundStyle(.black)
               .buttonStyle(.borderedProminent)
        Spacer()
        Button("Save",
               action: save)
        .disabled(title.isEmpty)
        .foregroundStyle(.black)
        .buttonStyle(.borderedProminent)
        Spacer()
      }
    }
    .headerProminence(.increased)
    .foregroundStyle(.blue)
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
