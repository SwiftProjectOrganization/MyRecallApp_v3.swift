//
//  AddQuestionLinkView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/29/24.
//

import SwiftUI
import SwiftData

struct AddQuestionLinkView {
  @State private var title = ""
  @State private var isHelpShown: Bool = false
  @Environment(\.scenePhase) private var scenePhase
  @FocusState private var focusField
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) var context
  var question: Question?
}

extension AddQuestionLinkView: View {
  var body: some View {
    NavigationStack {
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
        AddQuestionLinkViewHelpScreen()
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

extension AddQuestionLinkView {
  func save() {
    focusField = true
    let newLink: QuestionOnlineLink = QuestionOnlineLink(title,
                          .website,
                          question)
    question!.links!.append(newLink)
    dismiss()
  }
}

#Preview {
  AddQuestionLinkView()
    .modelContainer(previewContainer)
}
