//
//  UpdateQuestionLinksView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/13/25.
//

import SwiftUI
import SwiftData

struct UpdateQuestionLinksView: View {
  @State private var isHelpShown: Bool = false
  @State private var linkType: String = ""
  @State private var selectedLinkType: LinkType = .website
  @State private var linkPhrase: String = ""
  @State private var questionTitle: String = ""
  @Environment(\.dismiss) private var dismiss
  var link: QuestionOnlineLink
}

extension UpdateQuestionLinksView {
  var body: some View {
    VStack {
      HStack {
        Spacer()
        Text("Update link for question:")
          .font(.title.bold())
          .foregroundColor(.primary.opacity(0.7))
        Spacer()
      }
      Spacer(minLength: 10.0)
      List {
        VStack {
          HStack {
            Spacer()
            Text("Subtopic:\n")
              .font(.headline)
              .foregroundColor(.secondary.opacity(0.7))
            Spacer()
          }
          HStack {
            Spacer()
            Text(link.question!.subTopic!.title!)
              .font(.headline)
              .foregroundColor(.primary.opacity(0.7))
            Spacer()
          }
          Spacer(minLength: 10.0)
          HStack {
            Spacer()
            Text("Question:\n")
              .font(.headline)
              .foregroundColor(.secondary.opacity(0.7))
            Spacer()
          }
          HStack {
            Spacer()
            Text(link.question!.title!)
              .foregroundColor(.primary.opacity(07))
            Spacer()
          }
          Spacer(minLength: 10.0)
          HStack {
            Spacer()
            Text("Link phrase:")
              .font(.headline)
              .foregroundColor(.secondary.opacity(0.7))
            Spacer()
          }
          TextField("Link phrase:", text: $linkPhrase, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .border(Color.red,
                    width: 3)
            .foregroundColor(.primary.opacity(0.7))
            .multilineTextAlignment(.center)
            .padding()
          Spacer()
          HStack {
            Spacer()
            Text("Link type:")
              .font(.headline)
              .foregroundColor(.secondary.opacity(0.7))
            Spacer()
          }
          HStack {
            Spacer()
            Picker("Please, select a link type:", selection: $selectedLinkType) {
              ForEach(LinkType.allCases) { option in
                Text(String(describing: option))
              }
              .pickerStyle(.wheel)
              .foregroundColor(.primary.opacity(0.7))
            }
            Spacer()
          }
          .textFieldStyle(.roundedBorder)
          .border(Color.red,
                  width: 3)
          .foregroundColor(.primary.opacity(07))
          .padding(.horizontal)
          Spacer(minLength: 40.0)
        }
      }
      .onAppear {
        linkType = link.linkType!.rawValue
        selectedLinkType = link.linkType!
        linkPhrase = link.urlString!
        questionTitle = link.question!.title!
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isHelpShown = true
          } label: {
            Label("Help", systemImage: "questionmark")
          }
        }
      }
      .sheet(isPresented: $isHelpShown) {
        UpdateQuestionLinksViewHelpScreen()
      }
      .headerProminence(.increased)
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
        .buttonStyle(.borderedProminent)
        Spacer()
      }
      Spacer(minLength: 20.0)
    }
    .headerProminence(.increased)
  }
}

extension UpdateQuestionLinksView {
  func save() {
    link.linkType = selectedLinkType
    link.urlString = linkPhrase
    dismiss()
  }
}

#Preview {
  UpdateQuestionLinksView(link: QuestionOnlineLink("https://www.apple.com",
                        .website,
                        previewQuestion))
  .modelContainer(previewContainer)
}
