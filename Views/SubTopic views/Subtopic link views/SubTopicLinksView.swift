//
//  SubTopicLinksView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import SwiftUI
import SwiftData

@MainActor
struct SubTopicLinksView {
  @Binding var areSubTopicLinksVisible: Bool
  @State private var isAddingSubTopicLink: Bool = false
  @State private var isHelpShown: Bool = false
  @Environment(\.modelContext) private var context
  @Query var subTopicOnlineLinks: [SubTopicOnlineLink]
  @Environment(\.dismiss) var dismiss
  var subTopic: SubTopic
}

extension SubTopicLinksView {
  private var subTopicLinks: [SubTopicOnlineLink] {
    subTopicOnlineLinks.filter { $0.subTopic == subTopic }
  }
}

extension SubTopicLinksView: View {
  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Spacer()
          Text("Show subtopic links")
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
              Spacer()
              Text("Links:")
                .font(.headline)
                .foregroundColor(.secondary.opacity(0.7))
              Spacer()
            }
            if subTopicLinks.isEmpty {
              Text("No links added yet.")
            } else {
              ForEach(subTopicLinks) { link in
                NavigationLink(LocalizedStringKey(link.urlString!.description),
                               value: link)                
              }
              .onDelete { indexSet in
                if let index = indexSet.first {
                  context.delete(subTopicLinks[index])
                }
              }
            }
          }
        }
        Spacer()
        HStack {
          Spacer()
          MRAButton(label: "Save") {
            areSubTopicLinksVisible = false
            done()
          }
          Spacer()
        }
      }
      .navigationDestination(for: SubTopicOnlineLink.self) { link in
        UpdateSubTopicLinksView(link: link)
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
          EditButton()
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isAddingSubTopicLink = true
          } label: {
            Label("Add Link", systemImage: "plus")
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
      .sheet(isPresented: $isAddingSubTopicLink) {
        AddSubTopicLinkView(subTopic: subTopic)
      }
      .sheet(isPresented: $isHelpShown) {
        SubTopicLinksViewHelpScreen()
      }
    }
  }
}

extension SubTopicLinksView {
  private func done() {
    dismiss()
  }
}

#Preview {
  SubTopicLinksView(areSubTopicLinksVisible: .constant(true),
                    subTopic: previewSubTopic)
  .modelContainer(previewContainer)
}
