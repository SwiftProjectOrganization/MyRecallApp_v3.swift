//
//  ShowQuestionLinksView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import SwiftUI
import SwiftData

@MainActor
struct QuestionLinksView {
  @Binding var areQuestionLinksVisible: Bool
  @State private var isAddingQuestionLink: Bool = false
  @State private var isHelpShown: Bool = false
  @Environment(\.modelContext) private var context
  @Query var questionOnlineLinks: [QuestionOnlineLink]
  @Environment(\.dismiss) var dismiss
  var question: Question
}

extension QuestionLinksView {
  private var questionLinks: [QuestionOnlineLink] {
    questionOnlineLinks.filter { $0.question! == question }
  }
}

extension QuestionLinksView: View {
  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Spacer()
          Text("Question links")
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
            Text(question.subTopic!.topic!.title!)
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
            Text(question.subTopic!.title!)
            Spacer()
          }
        }
      }
      HStack {
        Spacer()
        Text("Question:")
          .font(.headline)
          .foregroundStyle(.secondary.opacity(0.7))
        Spacer()
      }
      HStack {
        Spacer()
        Text(question.title!)
        Spacer()
      }
      Spacer()
      List {
        VStack {
          HStack {
            Spacer()
            Text("Links:")
              .font(.headline)
              .foregroundStyle(.secondary.opacity(0.7))
            Spacer()
          }
          if questionLinks.count > 0 {
            ForEach(questionLinks) { link in
              NavigationLink(LocalizedStringKey(link.urlString!.description),
                             value: link)
            }
            .onDelete { indexSet in
              if let index = indexSet.first {
                context.delete(questionLinks[index])
              }
            }
          } else {
            Text("No question links yet!")
              .padding()
          }
        }
      }
      Spacer()
      HStack {
        Spacer()
        MRAButton(label: "Save") {
          areQuestionLinksVisible = false
          done()
        }
        Spacer()
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
        QuestionLinksViewHelpScreen()
      }
    }
  }
}


extension QuestionLinksView {
  private func done() {
    dismiss()
  }
}

#Preview {
  QuestionLinksView(areQuestionLinksVisible: .constant(true),
                    question: previewQuestion)
  .modelContainer(previewContainer)
}
