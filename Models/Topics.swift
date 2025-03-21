//
//  Topics.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 2/6/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
public class Topic: Codable, Identifiable, Equatable, Hashable {
  enum CodingKeys: CodingKey {
    case title
    case includedInRecall, lastRecallCycle, noOfRecallCycles
    case subTopics, links, timeStamps

  }
  
  var title: String?
  var includedInRecall: Bool = true
  var lastRecallCycle: Date = Date()
  var noOfRecallCycles: Int = 0
  
  @Relationship(deleteRule: .cascade,
                inverse: \SubTopic.topic)
  var subTopics: [SubTopic]?
  
  @Relationship(deleteRule: .cascade,
                inverse: \TopicOnlineLink.topic)
  var links: [TopicOnlineLink]?
  
  @Relationship(deleteRule: .cascade,
                inverse: \TopicRecallTimeStamp.topic)
  var timeStamps: [TopicRecallTimeStamp]?
  
  init(_ title: String = "",
       _ includedInRecall: Bool = true,
       _ lastRecallCycle: Date = Date(),
       _ noOfRecallCycles: Int = 0,
       _ subTopics: [SubTopic] = []) {
    self.title = title
    self.includedInRecall = includedInRecall
    self.lastRecallCycle = lastRecallCycle
    self.noOfRecallCycles = noOfRecallCycles
    self.subTopics = subTopics
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    title = try container.decodeIfPresent(String.self, forKey: .title)!
    includedInRecall = try container.decode(Bool.self, forKey: .includedInRecall)
    lastRecallCycle = try container.decode(Date.self, forKey: .lastRecallCycle)
    noOfRecallCycles = try container.decode(Int.self, forKey: .noOfRecallCycles)
    links = try container.decodeIfPresent([TopicOnlineLink].self, forKey: .links)
    timeStamps = try container.decodeIfPresent([TopicRecallTimeStamp].self, forKey: .timeStamps)
    subTopics = try container.decodeIfPresent([SubTopic].self, forKey: .subTopics)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(title, forKey: .title)
    try container.encode(includedInRecall, forKey: .includedInRecall)
    try container.encode(lastRecallCycle, forKey: .lastRecallCycle)
    try container.encode(noOfRecallCycles, forKey: .noOfRecallCycles)
    try container.encode(subTopics, forKey: .subTopics)
  }
}
