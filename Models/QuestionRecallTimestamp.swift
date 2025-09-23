//
//  QuestionRecallTimestamp.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import Foundation
import SwiftData

@Model
public class QuestionRecallTimeStamp: Codable {
  enum CodingKeys: String, CodingKey {
    case date
//    case question
  }
  
  var date: Date?
  
  var question: Question?
  
  init(date: Date = Date()) {
    self.date = date
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.date = try container.decodeIfPresent(Date.self, forKey: .date)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(date, forKey: .date)
  }
}
