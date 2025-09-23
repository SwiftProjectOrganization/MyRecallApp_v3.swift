//
//  ContentView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/29/24.
//

import SwiftUI
import SwiftData

var serverPath = "http://Rob-Work-M3.local:8080/api"

struct ContentView {
  @AppStorage("dirName") private var dirName = "MyRecallApp/Data"
  @AppStorage("noOfTimeStampsString") private var noOfTimeStampsString = "10"
  @AppStorage("remote") private var remote = "true"
  @AppStorage("defaultUser") private var defaultUser = "Rob"
  @AppStorage("urlPath") private var urlPath = "http://Rob-Work-M3.local:8080/api"
}

extension ContentView: View {
  var body: some View {
    TopicListView()
  }
}

#Preview {
  ContentView()
    .modelContainer(previewContainer)
}
