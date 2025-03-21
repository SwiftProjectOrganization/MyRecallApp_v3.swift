//
//  TopicLink.swift
//  MyRecallApp_v3
//
//  Created by Robert Goedman on 2/11/25.
//

import Foundation

import Foundation

extension Topic {
  func link(for linkType: LinkType) -> TopicOnlineLink? {
    // return first link in links with this linkType
    links?.first(where: {$0.linkType == linkType})
  }
  
  func setURL(for linkType: LinkType,
              to urlString: String) {
    if let link = link(for: linkType) {
      // change link's urlString
      link.urlString = urlString
    } else {
      // append a new TopicOnlineLink for this linkType and urlString
      links?.append(TopicOnlineLink(urlString,
                                       linkType,
                                      self))
    }
  }
}
