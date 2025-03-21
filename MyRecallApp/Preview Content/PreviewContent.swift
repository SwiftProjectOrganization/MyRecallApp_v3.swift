//
//  PreviewContent.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/29/24.
//

import Foundation
import SwiftData

let previewContainer: ModelContainer = {
  let schema = Schema([Topic.self, SubTopic.self, Question.self])
  let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
  do {
    let container = try ModelContainer(for: schema,
                                       configurations: configuration)
    try addSampleData(to: container)
    return container
  } catch {
    fatalError("Could not create container: \(error.localizedDescription)")
  }
}()

fileprivate var topics: [Topic] = [Topic("Huberman"),
                                       Topic("Spanish"),
                                       Topic("Cech"),
                                       Topic("Markup")]

fileprivate var subTopics = [SubTopic("Huberman: Essentials 1"),
                              SubTopic("Huberman: Neuromodulators"),
                              SubTopic("Spanish: Irregular verbs")]

fileprivate let answers: [String] = ["""
The nervous system comprises your brain, the spinal cord and all the connections to organs and tissue. It also includes all connections back from organs to the spinal cord and the brain.
""",
"""
Our brain is really a map of our experiences. It records or learns these experiences from 1. **sensations**, 2. **perceptions** (and **attention**), 3. **feelings** and **emotions**, 4. **thoughts** and 6. **Actions**.
""",
  "Answer for dopamine",
  "hizo",
  "no pudo ir"
]

fileprivate var questions = [Question("What's your nervous system?",
                                     answers[0]),
                             Question("What are the functions of your brain?",
                                     answers[1]),
                             Question("What is dopamine?",
                                     answers[2]),
                             Question("I did",
                                     answers[3]),
                             Question("I could not go",
                                     answers[4])
]

fileprivate let subTopicLinks: [SubTopicOnlineLink] = [
  SubTopicOnlineLink("[Apple](https://apple.com)",
                     .website,
                     subTopics[0]),
  SubTopicOnlineLink("[Huberman](https://hubermanlab.com)",
                     .website,
                    subTopics[0]),
]

fileprivate let questionLinks: [QuestionOnlineLink] = [
  QuestionOnlineLink("[Apple](https://apple.com)",
                     .website,
                     questions[0]),
  QuestionOnlineLink("[Huberman](https://hubermanlab.com)",
                     .website,
                     questions[1]),
]

fileprivate func assign(_ questions: [Question],
                        _ subTopics: [SubTopic]) {
  subTopics[0].topic = topics[0]
  subTopics[1].topic = topics[0]
  subTopics[2].topic = topics[0]

  questions[0].subTopic = subTopics[0]
  questions[1].subTopic = subTopics[0]
  questions[2].subTopic = subTopics[1]
  questions[3].subTopic = subTopics[2]
  questions[4].subTopic = subTopics[2]
}

fileprivate func addSampleData(to container: ModelContainer) throws {
  let context = ModelContext(container)
  for mainTopic in topics {
    context.insert(mainTopic)
  }
  for subTopic in subTopics {
    context.insert(subTopic)
  }
  for question in questions {
    context.insert(question)
  }
  for link in subTopicLinks {
    context.insert(link)
  }
  for link in questionLinks {
    context.insert(link)
  }
  assign(questions, subTopics)
  for subTopic in subTopics {
    subTopic.timeStamps?.append(SubTopicRecallTimeStamp())
  }
  try context.save()
}

let previewQuestion: Question = {
  let context = ModelContext(previewContainer)
  if let question = try? context.fetch(FetchDescriptor<Question>()).first {
    return previewQuestion
  } else {
    fatalError( "Couldn't find a question.")
  }
}()


let previewSubTopic: SubTopic = {
  let context = ModelContext(previewContainer)
  if let question = try? context.fetch(FetchDescriptor<SubTopic>()).first {
    return previewSubTopic
  } else {
    fatalError( "Couldn't find a category.")
  }
}()

let previewTopic: Topic = {
  let context = ModelContext(previewContainer)
  if let topic = try? context.fetch(FetchDescriptor<Topic>()).first {
    return previewTopic
  } else {
    fatalError( "Couldn't find a category.")
  }
}()

