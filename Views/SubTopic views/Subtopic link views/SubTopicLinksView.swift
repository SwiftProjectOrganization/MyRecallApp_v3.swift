//
//  SubTopicLinksView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import SwiftUI
import SwiftData

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
      HStack {
        Spacer()
        Text("Show subtopic links:")
          .font(.title.bold())
          .foregroundColor(.primary.opacity(0.7))
          .multilineTextAlignment(.center)
        Spacer()
      }
      Spacer(minLength: 40.0)
      List {
        VStack {
          HStack {
            Spacer()
            Text("Subtopic:\n")
              .font(.headline)
              .foregroundStyle(.secondary.opacity(0.7))
            Spacer()
          }
          Spacer()
          HStack {
            Spacer()
            Text(subTopic.title!)
            Spacer()
          }
          Spacer(minLength: 40.0)

          HStack {
            Spacer()
            Text("Links:")
              .font(.headline)
              .foregroundColor(.secondary.opacity(0.7))
            Spacer()
          }
          Spacer()
        }
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
      .headerProminence(.increased)
        HStack {
          Spacer()
          Button("Save") {
            areSubTopicLinksVisible = false
            done()
          }
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
          .multilineTextAlignment(.center)
          Spacer()
        }
        Spacer(minLength: 20.0)
      }
    .headerProminence(.increased)
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
