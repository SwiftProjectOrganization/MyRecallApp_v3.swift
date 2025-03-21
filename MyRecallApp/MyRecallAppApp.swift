//
//  MyRecallAppApp.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/29/24.
//

import SwiftUI
import SwiftData

@main
struct MyRecallAppApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Topic.self, SubTopic.self, Question.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  var body: some Scene {
    WindowGroup {
      return ContentView()
    }
    .modelContainer(sharedModelContainer)
  }
}
