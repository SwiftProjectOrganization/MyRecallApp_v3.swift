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
        Text("Add a topic")
          .font(.title.bold())
          .foregroundStyle(.blue)
        Spacer()
      }
      .padding(.vertical, 60.0)
      VStack {
        HStack {
          Spacer()
          TextField("Topic title", text: $title, axis: .vertical)
            .focused($focusField)
            .font(.largeTitle)
            .padding()
            .multilineTextAlignment(.leading)
            .textFieldStyle(.roundedBorder)
            .border(Color.red,
                    width: 3)
          Spacer()
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
    Spacer()
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
