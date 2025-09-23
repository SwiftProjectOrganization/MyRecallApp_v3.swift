//
//  ImportJSONView.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/27/25.
//

import SwiftUI
import SwiftData
import OpenAPIRuntime
import OpenAPIURLSession

struct LocalImportJSONView {
  @AppStorage("dirName") private var dirName: String = "MyRecallApp/Data"
  @AppStorage("remote") private var remote: String = "false"

  @Binding var isLocalImportJSONShown: Bool
  @State private var isHelpShown: Bool = false
  @State private var selection: Set<URL> = []
  
  @State private var result: String = "No responses yet"
  
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss
  @Query private var topics: [Topic]
}

extension LocalImportJSONView {
  func getOldTopics(topicTitle: String) -> Topic? {
    topics.filter { $0.title == topicTitle }.first
  }
}

extension LocalImportJSONView: View  {
  var body: some View {
    NavigationStack {
      HStack {
        Spacer()
        Text("Select topics to import:")
          .font(.title.bold())
          .foregroundColor(.primary.opacity(0.7))
        Spacer()
      }
      List(getJSONFiles(path: dirName)!, id: \.self, selection: $selection) { url in
        Text(url.path.split(separator: "/").last!.replacingOccurrences(of: "_", with: " "))
      }
      Spacer()
        .sheet(isPresented: $isHelpShown) {
          ImportJSONViewHelpScreen()
        }
      HStack {
        Spacer()
        Button("Cancel") {
          dismiss()
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        Spacer()
        Button("Import selected topics") {
          getTopics()
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(.center)
        .disabled(selection.isEmpty)
        .padding()
        .headerProminence(.increased)
        Spacer()
      }
      Spacer(minLength: 20.0)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            dismiss()
          } label: {
            Label("Back", systemImage: "lessthan")
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          EditButton()
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isHelpShown = true
          } label: {
            Label("Help", systemImage: "questionmark")
          }
        }
      }
    }
  }
}

extension LocalImportJSONView {
  func getTopics() {
    isLocalImportJSONShown = false
    for selected in selection {
      let topic = importJSONFiles(urls: [selected]).first!
      print(topic.title!)
      context.insert(topic)
    }
  }
}

extension LocalImportJSONView {
  func importJSONFiles(urls: [URL]) -> [Topic] {
    //var topic: Topic
    var topics: [Topic] = []
    
    for url in urls {
      var jsonData: Data? = nil
      do {
        jsonData = try Data(contentsOf: url)
      } catch {
        print("Error reading file: \(error)")
      }
      
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601 // Use ISO 8601 date format
      do {
        let newTopic = try decoder.decode(Topic.self, from: jsonData!)
        print("Decoded `\(String(describing: newTopic.title))` from json file `\(String(describing: url.path))`.")
        //newTopic.prettyPrintJSON()
        
        let oldTopic = getOldTopics(topicTitle: newTopic.title!)
        if oldTopic != nil {
          print("Deleting old topic with title \(oldTopic!.title!)")
          context.delete(oldTopic!)
          do {
            try context.save()
          } catch {
            print(error.localizedDescription)
          }
        }
        topics.append(newTopic)
      } catch {
        print("Error decoding JSON: \(error)")
      }
    }
    return topics
  }
}
