//
//  SubTopicOnlineLink.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import Foundation
import SwiftData

@Model
public class SubTopicOnlineLink: Codable {
  enum CodingKeys: String, CodingKey {
    case linkType
    case urlString
  }
  
  var linkType: LinkType?
  var urlString: String?
  var subTopic: SubTopic?
  
  init(_ urlString: String,
       _ linkType: LinkType,
       _ subTopic: SubTopic? = nil) {
    self.linkType = linkType
    self.urlString = urlString
    self.subTopic = subTopic
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
