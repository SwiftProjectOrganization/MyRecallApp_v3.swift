//
//  UpdateSubTopicLinksView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/13/25.
//

import SwiftUI
import SwiftData

struct UpdateSubTopicLinksView: View {
  @State private var isHelpShown: Bool = false
  @State private var linkType: String = ""
  @State private var selectedLinkType: LinkType = .website
  @State private var linkPhrase: String = ""
  @State private var subTopicTitle: String = ""
  @Environment(\.dismiss) private var dismiss
  var link: SubTopicOnlineLink
}

extension UpdateSubTopicLinksView {
  var body: some View {
    VStack {
      HStack {
        Spacer()
        Text("Update link for category:")
          .font(.title.bold())
          .multilineTextAlignment(.center)
        Spacer()
      }
      List {
        VStack {
          HStack {
            Spacer()
            Text("Category:\n")
              .font(.headline)
              .foregroundColor(.secondary.opacity(0.7))
            Spacer()
          }
          HStack {
            Spacer()
            Text(link.subTopic!.title!)
            Spacer()
          }
          Spacer(minLength: 40.0)
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
            Picker("Please choose a link type:", selection: $selectedLinkType) {
              ForEach(LinkType.allCases) { option in
                Text(String(describing: option))
              }
              .pickerStyle(.wheel)
             }
            Spacer()
          }
          .textFieldStyle(.roundedBorder)
          .border(Color.red,
                  width: 3)
          .padding()
          Spacer(minLength: 40.0)
        }
      }
      .onAppear {
        linkType = link.linkType!.rawValue
        selectedLinkType = link.linkType!
        linkPhrase = link.urlString!
        subTopicTitle = link.subTopic!.title!
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
        UpdateSubTypeLinkViewHelpScreen()
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
    .foregroundColor(.primary.opacity(0.7))
  }
}

extension UpdateSubTopicLinksView {
  func save() {
    link.linkType = selectedLinkType
    link.urlString = linkPhrase
    dismiss()
  }
}

#Preview {
  UpdateSubTopicLinksView(link: SubTopicOnlineLink("https://www.apple.com",
                        .website,
                        previewSubTopic))
    .modelContainer(previewContainer)
}
