//
//  ShowQuestionLinksView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import SwiftUI
import SwiftData

struct ShowQuestionLinksView {
  @Binding var areQuestionLinksVisible: Bool
  @State private var isAddingQuestionLink: Bool = false
  @State private var isHelpShown: Bool = false
  @Environment(\.modelContext) private var context
  @Query var questionOnlineLinks: [QuestionOnlineLink]
  @Environment(\.dismiss) var dismiss
  var question: Question
}

extension ShowQuestionLinksView {
  private var questionLinks: [QuestionOnlineLink] {
    questionOnlineLinks.filter { $0.question! == question }
  }
}

extension ShowQuestionLinksView: View {
  var body: some View {
    NavigationStack {
      HStack {
        Spacer()
        Text("Show question links:")
          .font(.title.bold())
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
            Text(question.subTopic!.title!)
            Spacer()
          }
          Spacer(minLength: 40.0)
          HStack {
            Spacer()
            Text("Question:\n")
              .font(.headline)
              .foregroundStyle(.secondary.opacity(0.7))
            Spacer()
          }
          Spacer()
          HStack {
            Spacer()
            Text(question.title!)
            Spacer()
          }
          Spacer(minLength: 40.0)
          HStack {
            Spacer()
            Text("Links:")
              .font(.headline)
              .foregroundStyle(.secondary.opacity(0.7))
            Spacer()
          }
          Spacer()
        }
        ForEach(questionLinks) { link in
          NavigationLink(LocalizedStringKey(link.urlString!.description),
                         value: link)
        }
        .onDelete { indexSet in
          if let index = indexSet.first {
            context.delete(questionLinks[index])
          }
        }
      }
      .navigationDestination(for: QuestionOnlineLink.self) { link in
        UpdateQuestionLinksView(link: link)
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            dismiss()
          } label: {
            Label("Back", systemImage: "lessthan")
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          EditButton()
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isAddingQuestionLink = true
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
      .sheet(isPresented: $isAddingQuestionLink) {
        AddQuestionLinkView(question: question)
      }
      .sheet(isPresented: $isHelpShown) {
        ShowQuestionLinksViewHelpScreen()
      }
      .headerProminence(.increased)
      HStack {
        Spacer()
        Button("Save") {
          areQuestionLinksVisible = false
          done()
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
      }
      Spacer(minLength: 20.0)
    }
    .foregroundStyle(.primary.opacity(0.7))
  }
}

extension ShowQuestionLinksView {
  private func done() {
    dismiss()
  }
}

#Preview {
  ShowQuestionLinksView(areQuestionLinksVisible: .constant(true),
                        question: previewQuestion)
  .modelContainer(previewContainer)
}
