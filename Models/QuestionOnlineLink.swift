//
//  QuestionOnlineLink.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import Foundation
import SwiftData

@Model
public class QuestionOnlineLink: Codable {
  enum CodingKeys: String, CodingKey {
    case linkType
    case urlString
//    case question
}
  
  var linkType: LinkType?
  var urlString: String?
  
  var question: Question?
  
  init(_ urlString: String,
       _ linkType: LinkType,
       _ question: Question? = nil) {
    self.linkType = linkType
    self.urlString = urlString
    self.question = question
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    linkType = try container.decodeIfPresent(LinkType.self, forKey: .linkType)
    urlString = try container.decodeIfPresent(String.self, forKey: .urlString)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(linkType, forKey: .linkType)
    try container.encodeIfPresent(urlString, forKey: .urlString)
  }
}
