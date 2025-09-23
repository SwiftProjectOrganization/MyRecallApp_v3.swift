//
//  SubTopic.swift
//  MyRecallApp_v3
//
//  Created by Robert Goedman on 12/29/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
public class SubTopic: Codable, Identifiable, Equatable, Hashable {
  enum CodingKeys: CodingKey {
    case title
    case includedInRecall, lastRecallCycle, noOfRecallCycles
    case topic, questions, links, timeStamps
  }
  
  var title: String?
  
  var includedInRecall: Bool = true
  var lastRecallCycle: Date = Date()
  var noOfRecallCycles: Int = 0
  
  var topic: Topic?
  
  @Relationship(deleteRule: .cascade,
                inverse: \Question.subTopic)
  var questions: [Question]?
  
  @Relationship(deleteRule: .cascade,
                inverse: \SubTopicOnlineLink.subTopic)
  var links: [SubTopicOnlineLink]?
  
  @Relationship(deleteRule: .cascade,
                inverse: \SubTopicRecallTimeStamp.subTopic)
  var timeStamps: [SubTopicRecallTimeStamp]?
  
  init(_ title: String = "",
       _ topic: Topic? = nil,
       _ includedInRecall: Bool = true,
       _ lastRecallCycle: Date = Date(),
       _ noOfRecallCycles: Int = 0,
       _ questions: [Question] = [],
       _ links: [SubTopicOnlineLink] = [],
       _ timeStamp: SubTopicRecallTimeStamp = SubTopicRecallTimeStamp()) {
    self.title = title
    self.includedInRecall = includedInRecall
    self.lastRecallCycle = lastRecallCycle
    self.noOfRecallCycles = noOfRecallCycles
    self.topic = topic
    self.questions = questions
    self.links = links
    self.timeStamps = [timeStamp]
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    title = try container.decodeIfPresent(String.self, forKey: .title)!
    includedInRecall = try container.decode(Bool.self, forKey: .includedInRecall)
    lastRecallCycle = try container.decode(Date.self, forKey: .lastRecallCycle)
    noOfRecallCycles = try container.decode(Int.self, forKey: .noOfRecallCycles)
    questions = try container.decodeIfPresent([Question].self, forKey: .questions)
    links = try container.decodeIfPresent([SubTopicOnlineLink].self, forKey: .links)
    timeStamps = try container.decodeIfPresent([SubTopicRecallTimeStamp].self, forKey: .timeStamps)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(title, forKey: .title)
    try container.encode(includedInRecall, forKey: .includedInRecall)
    try container.encode(lastRecallCycle, forKey: .lastRecallCycle)
    try container.encode(noOfRecallCycles, forKey: .noOfRecallCycles)
    try container.encode(questions, forKey: .questions)
    try container.encode(links, forKey: .links)
    try container.encode(timeStamps, forKey: .timeStamps)
  }
}
