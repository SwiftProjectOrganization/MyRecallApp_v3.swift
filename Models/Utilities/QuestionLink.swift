//
//  QuestionLink.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/30/24.
//

import Foundation

extension Question {
  func link(for linkType: LinkType) -> QuestionOnlineLink? {
    // return first link in links with this linkType
    links?.first(where: {$0.linkType == linkType})
  }
  
  func setURL(for linkType: LinkType,
              to urlString: String) {
    if let link = link(for: linkType) {
      // change link's urlString
      link.urlString = urlString
    } else {
      // append a new QuestionOnlineLink for this linkType and urlString
      links?.append(QuestionOnlineLink(urlString,
                                       linkType,
                                      self))
    }
  }
}
