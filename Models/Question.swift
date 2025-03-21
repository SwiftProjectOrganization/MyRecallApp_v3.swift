//
//  Question.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/29/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
public class Question: Codable {
  enum CodingKeys: CodingKey {
    case title
    case answer
    case userAnswer
    case includedInRecall, lastRecallCycle, noOfRecallCycles
    case links, timeStamps
  }
  
  var title: String?
  var answer: String = ""
  var userAnswer: String = ""
  
  var includedInRecall: Bool = true
  var lastRecallCycle: Date = Date()
  var noOfRecallCycles: Int = 0
  
  var subTopic: SubTopic?
  
  @Relationship(deleteRule: .cascade,
                inverse: \QuestionOnlineLink.question)
  var links: [QuestionOnlineLink]?
  
  @Relationship(deleteRule: .cascade,
                inverse: \QuestionRecallTimeStamp.question)
  var timeStamps: [QuestionRecallTimeStamp]?
  
  init(_ title: String = "",
       _ answer: String = "",
       _ userAnswer: String = "",
       _ includedInRecall: Bool = true,
       _ lastRecallCycle: Date = Date(),
       _ noOfRecallCycles: Int = 0,
       _ subTopic: SubTopic? = nil,
       _ links: [QuestionOnlineLink]? = nil,
       _ timeStamps: [QuestionRecallTimeStamp] = [QuestionRecallTimeStamp()]) {
    self.title = title
    self.answer = answer
    self.userAnswer = userAnswer
    self.includedInRecall = includedInRecall
    self.lastRecallCycle = lastRecallCycle
    self.noOfRecallCycles = noOfRecallCycles
    self.subTopic = subTopic
    self.links = links
    self.timeStamps = timeStamps
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    title = try container.decodeIfPresent(String.self, forKey: .title)
    answer = try container.decode(String.self, forKey: .answer)
    userAnswer = try container.decode(String.self, forKey: .userAnswer)
    includedInRecall = try container.decode(Bool.self, forKey: .includedInRecall)
    lastRecallCycle = try container.decode(Date.self, forKey: .lastRecallCycle)
    noOfRecallCycles = try container.decode(Int.self, forKey: .noOfRecallCycles)
//    category = try container.decodeIfPresent(Category.self, forKey: .category)
    links = try container.decodeIfPresent([QuestionOnlineLink].self, forKey: .links)
    timeStamps = try container.decode([QuestionRecallTimeStamp].self, forKey: .timeStamps)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(title, forKey: .title)
    try container.encode(answer, forKey: .answer)
    try container.encode(userAnswer, forKey: .userAnswer)
    try container.encode(includedInRecall, forKey: .includedInRecall)
    try container.encode(lastRecallCycle, forKey: .lastRecallCycle)
    try container.encode(noOfRecallCycles, forKey: .noOfRecallCycles)
//    try container.encodeIfPresent(category, forKey: .category)
    try container.encodeIfPresent(links, forKey: .links)
    try container.encodeIfPresent(timeStamps, forKey: .timeStamps)
  }
  
}
