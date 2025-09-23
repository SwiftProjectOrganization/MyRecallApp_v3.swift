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
    NavigationStack {
      VStack {
        HStack {
          Spacer()
          Text("Update link for subtopic")
            .font(.title.bold())
            .foregroundStyle(Color.blue)
            .multilineTextAlignment(.center)
          Spacer()
        }
        VStack {
          HStack {
            Spacer()
            Text("Topic:\n")
              .font(.headline)
              .foregroundColor(.secondary.opacity(0.7))
            Spacer()
          }
          HStack {
            Spacer()
            Text(link.subTopic!.topic!.title!)
            Spacer()
          }
          HStack {
            Spacer()
            Text("Subtopic:\n")
              .font(.headline)
              .foregroundColor(.secondary.opacity(0.7))
            Spacer()
          }
          HStack {
            Spacer()
            Text(link.subTopic!.title!)
            Spacer()
          }
        }
        List {
          VStack {
            Spacer()
            HStack {
              Spacer()
              Text("Link phrase:")
                .font(.headline)
                .foregroundColor(.secondary.opacity(0.7))
              Spacer()
            }
            TextField("Link phrase:", text: $linkPhrase, axis: .vertical)
              .textFieldStyle(.roundedBorder)
              .padding()
              .border(Color.red,
                      width: 3)
              .multilineTextAlignment(.center)
              .padding()
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
            .padding()
            .border(Color.red,
                    width: 3)
            .padding()
            Spacer(minLength: 40.0)
          }
        }
      }
      .onAppear {
        linkType = link.linkType!.rawValue
        selectedLinkType = link.linkType!
        linkPhrase = link.urlString!
        subTopicTitle = link.subTopic!.title!
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            dismiss()
          } label: {
            Label("<", systemImage: "<")
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
      .sheet(isPresented: $isHelpShown) {
        UpdateSubTypeLinkViewHelpScreen()
      }
      HStack {
        Spacer()
        MRAButton(label: "Cancel") {
          dismiss()
        }
        Spacer()
        MRAButton(label: "Save") {
          save()
        }
        Spacer()
      }
      Spacer()
    }
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
