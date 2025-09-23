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

struct JSONRemoteImportView {
  @AppStorage("dirName") private var dirName = "MyRecallApp/Data"
  @AppStorage("urlPath") private var urlPath = serverPath
  @AppStorage("remote") private var remote = "false"
  
  @State private var isRemoteImportJSONShown: Bool = true
  @State private var isHelpShown: Bool = false
  @State private var selection: Set<String> = []
  
  @State private var result: String = "No responses yet"
  @State private var jsonFiles: [String] = []
  
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss
  @Query private var topics: [Topic]
  
  let client: any APIProtocol
  init(client: any APIProtocol) { self.client = client }
  init() {
    self.init(
      client: Client(serverURL: URL(string: serverPath)!,
                     transport: URLSessionTransport())
    )
  }
}

extension JSONRemoteImportView {
  func getOldTopic(topicTitle: String) -> Topic? {
    topics.filter { $0.title == topicTitle }.first
  }
}

@MainActor
extension JSONRemoteImportView: View  {
  var body: some View {
    NavigationStack {
      HStack {
        Spacer()
        Text("Select topics to import:")
          .font(.title.bold())
          .foregroundColor(.primary.opacity(0.7))
        Spacer()
      }
      List(jsonFiles, id: \.self, selection: $selection) { rstr in
        Text(String(rstr.replacingOccurrences(of: "_", with: " ")).description)
      }
      .task {
        jsonFiles = await getJSONFileNames()
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
      Text(result)
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

extension JSONRemoteImportView {
  func getJSONFileNames(path: String = "MyRecallApp/Data") async -> [String] {
    do {
      let response = try await client.listTopics(
        query: .init(user: "Rob"))
      result = try response.ok.body.json.message
      jsonFiles = splitJSONFileNames(str: result)
      result = ""
      for topic in jsonFiles {
        result.append( Substring(topic.split(separator: ".").first!) + ", " )
      }
      result.remove(at: result.index(before: result.endIndex))
      result.remove(at: result.index(before: result.endIndex))
      return jsonFiles
    } catch {
      result = "Error: \(error.localizedDescription)"
      return []
    }
  }
}

func splitJSONFileNames(str: String) -> [String] {
  var cleanedString = str
  cleanedString.remove(at: cleanedString.startIndex)
  cleanedString.remove(at: cleanedString.index(before: cleanedString.endIndex))
  let splitSubString = cleanedString.split(separator: ",")
  var splitString: [String] = []
  for subString in splitSubString {
    var sString = subString.trimmingCharacters(in: .whitespacesAndNewlines)
    sString.remove(at: sString.startIndex)
    sString.remove(at: sString.index(before: sString.endIndex))
    splitString.append(String(sString))
  }
  let jsonFiles = splitString.filter { $0.hasSuffix(".json") }.map { $0 }
  return jsonFiles
}

@MainActor
extension JSONRemoteImportView {
  func getTopics() {
    isRemoteImportJSONShown = false
    for selected in selection {
      Task {
        do {
          let newTopicTitle = String(selected.split(separator: ".").first!)
          let response = try await client.getJson(
            query: .init(user: "Rob",
                         topic: newTopicTitle))
          result = try response.ok.body.json.message
          //print(result)
          var jsonData: Data? = nil
          jsonData = Data(result.utf8)
          
          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .iso8601 // Use ISO 8601 date format
          do {
            let newTopic = try decoder.decode(Topic.self, from: jsonData!)
            //newTopic.prettyPrintJSON()
            print("Decoded topic with title \(newTopic.title!)")
            let theOldTopic = getOldTopic(topicTitle: newTopicTitle)
            if theOldTopic != nil {
              print("Deleting old topic with title \(theOldTopic!.title!)")
              context.delete(theOldTopic!)
              do {
                try context.save()
                result = "Imported \(newTopic.title!)"
              } catch {
                print("Failed to save context after deleting topic with title \(theOldTopic!.title!)")
              }
            } else {
              print("No topic with title \(newTopicTitle) to delete")
            }
            context.insert(newTopic)
          } catch {
            print("Error decoding JSON: \(error)")
          }
        } catch {
          result = "Error: \(error.localizedDescription)"
        }
      }
    }
    //dismiss()
  }
}
