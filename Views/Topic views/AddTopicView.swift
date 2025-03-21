//
//  AddTopicView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 2/6/25.
//

import SwiftUI
import SwiftData

struct AddTopicView {
  @State private var title = ""
  @State private var isHelpShown: Bool = false
  @Environment(\.scenePhase) private var scenePhase
  @FocusState private var focusField
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) var context
}

extension AddTopicView: View {
  var body: some View {
    NavigationStack {
      HStack {
        Spacer()
        Text("Add topic:")
          .font(.title.bold())
          .foregroundColor(.primary.opacity(0.7))
        Spacer()
      }
      .padding(.vertical, 40.0)
      List {
        HStack {
          TextField("Topic title", text: $title)
            .focused($focusField)
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .padding()
        }
        .onAppear {
          focusField = true
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
      AddTopicViewHelpScreen()
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

extension AddTopicView {
  func save() {
    focusField = true
    context.insert(Topic(title))
    dismiss()
  }
}

#Preview {
  AddTopicView()
    .modelContainer(previewContainer)
}
