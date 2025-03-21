//
//  QuestionsListView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/29/24.
//

import SwiftUI
import SwiftData

struct QuestionsListView {
  @State private var isUpdatePresented = false
  @State private var areCategoryTimeStampsVisible = false
  @State private var areCategoryLinksVisible = false
  @State private var isAddingQuestion = false
  @State private var isHelpShown = false
  @State private var includedInRecall: Bool = true
  @Environment(\.modelContext) var context
  @Environment(\.dismiss) private var dismiss
  @Query var questions: [Question]
  var category: Category
}

extension QuestionsListView {
  private var categoryQuestions: [Question] {
    questions.filter { $0.category == category}.sorted { $0.title! < $1.title! }
  }
}

extension QuestionsListView: View {
  var body: some View {
    VStack {
      HStack {
        Spacer()
        Text("Questions List for category:\n\(category.title!)")
          .font(.title.bold())
          .foregroundColor(.primary.opacity(0.7))
          .multilineTextAlignment(.center)
        Spacer()
      }
      Spacer(minLength: 40.0)
      List {
        if categoryQuestions.count > 0 {
          ForEach(categoryQuestions) { question in
            NavigationLink(question.title!,
                           value: question)
          }
          .onDelete { indexSet in
            if let index = indexSet.first {
              context.delete(categoryQuestions[index])
            }
          }
        } else {
          Text("No questions yet")
        }
      }
      .listStyle(.insetGrouped)
      .headerProminence(.increased)
        HStack {
          Spacer()
          Button("Update category") {
            isUpdatePresented = true
          }
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
          .multilineTextAlignment(.center)
          Spacer()
          Button("Show category links") {
            areCategoryLinksVisible = true
          }
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
          .multilineTextAlignment(.center)
          Spacer()
          Button("Show category recall timestamps") {
            areCategoryTimeStampsVisible = true
          }
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
          .multilineTextAlignment(.center)
          Spacer()
        }
        .headerProminence(.increased)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            EditButton()
          }
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              isAddingQuestion = true
            } label: {
              Label("Add Question", systemImage: "plus")
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
        .navigationDestination(for: Question.self) { question in
          IndividualQuestionView(question: question)
        }
        .sheet(isPresented: $isAddingQuestion) {
          AddQuestionView(category: category)
        }
        .sheet(isPresented: $isUpdatePresented) {
          UpdateCategoryView(isUpdatePresented: .constant(true),
                                       category: category)
        }
        .sheet(isPresented: $areCategoryTimeStampsVisible) {
          CategoryTimeStampsView(areCategoryTimeStampsVisible: .constant(true),
                                 category: category)
        }
        .sheet(isPresented: $areCategoryLinksVisible) {
          CategoryLinksView(areCategoryLinksVisible: .constant(true),
                            category: category)
        }
        .sheet(isPresented: $isHelpShown) {
          QuestionViewHelpScreen()
        }
      }
      .headerProminence(.increased)
    }
  }

#Preview {
  QuestionsListView(category: previewCategory)
    .modelContainer(previewContainer)
}
