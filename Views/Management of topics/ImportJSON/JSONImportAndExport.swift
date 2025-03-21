//
//  JSONImportAndExport.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/27/25.
//

import Foundation

func createFileURL(dirName: String, fileName: String) -> URL? {
  let _ = FileManager.default
  let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  let dirURL = documentsURL.appendingPathComponent(dirName)
  
  do {
    try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
  } catch {
    print("Error creating directory: \(error)")
  }
  let fileURL = dirURL.appendingPathComponent(fileName)
  return fileURL
}

func createJSONstring(topic: Topic) -> String? {
  let encoder = JSONEncoder()
  encoder.dateEncodingStrategy = .iso8601 // Use ISO 8601 date format
  var jsonString: String? = ""
  
  do {
    let jsonData = try encoder.encode(topic)
    jsonString = String(data: jsonData, encoding: .utf8) ?? nil
    if jsonString != nil  {
      //print(jsonString!) // Prints the JSON string
      return jsonString
    } else {
      return nil
    }
  } catch {
    print("Error encoding article: \(error)")
    return nil
  }
}

func writeJSONFiles(topics: Set<Topic>,
                    path: String = "MyRecallApp/Data") {
  for topic in topics {
    let trimmed = topic.title!.trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(of: " ", with: "_")
    let fileURL = createFileURL(dirName: path,
                                fileName: trimmed + ".json")
    print(fileURL!)
    let json = createJSONstring(topic: topic)
    if json != nil {
      json!.prettyPrintJSON()
    }
    
    if let data = json!.data(using: .utf8) {
      do {
        try data.write(to: fileURL!)
        print("Successfully wrote `\(String(describing:topic.title))' to file `\(String(describing: trimmed))")
      } catch {
        print("Error writing to file: \(error)")
      }
    }
  }
}

func getJSONFiles(path: String = "MyRecallApp/Data") -> [URL]? {
  var jsonFiles: [URL] = []
  
  do {
    // Get the mainTopic JSON file directory url
    let dirURL = try FileManager.default.url(for: .documentDirectory,
                                             in: .userDomainMask,
                                             appropriateFor: nil,
                                             create: true)
      .appendingPathComponent(path)
    
    // Get the directory contents urls (including subfolders urls)
    let topicURLs = try FileManager.default.contentsOfDirectory(
      at: dirURL,
      includingPropertiesForKeys: nil
    )
    jsonFiles = topicURLs.filter { $0.lastPathComponent.hasSuffix(".json") }.map { $0 }
    jsonFiles.sort { $0.path.split(separator: "/").last! < $1.path.split(separator: "/").last! }
      
    return jsonFiles
  } catch {
    print(error)
    return nil
  }
}

func importJSONFiles(urls: [URL]) -> [Topic] {
  var topic: Topic
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
      topic = try decoder.decode(Topic.self, from: jsonData!)
      topic.prettyPrintJSON()
      print("Restored `\(String(describing: topic.title))` from json file `\(String(describing: url.path))`.")
      topics.append(topic)
    } catch {
      print("Error decoding JSON: \(error)")
    }
  }
  return topics
}

extension Encodable {
    public func prettyPrintJSON() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let encodedData = try? encoder.encode(self) else {
            print("Failed to encode data")
            return
        }
        
        let prettyJSONString = String(decoding: encodedData, as: UTF8.self)
        print(prettyJSONString)
    }
}
