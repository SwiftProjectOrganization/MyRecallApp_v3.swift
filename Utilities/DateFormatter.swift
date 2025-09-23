//
//  DateFormatter.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/31/24.
//

import Foundation

func formatDate(_ date: Date) -> String {
  let formatter = DateFormatter()
  formatter.dateFormat = "MM/dd/yyyy HH:mm"
  return formatter.string(from: date)
}
