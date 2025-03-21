//
//  ContentView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 12/29/24.
//

import SwiftUI
import SwiftData

struct ContentView {
  @AppStorage("appDataDirName") var appDataDirName: String = "MyRecallApp/Data"
  @AppStorage("noOfTimeStamps") var noOfTimeStamps: Int = 10
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
