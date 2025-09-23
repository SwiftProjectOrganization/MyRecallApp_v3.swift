//
//  JSONImportAndExport.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/27/25.
//

import Foundation

func createFileURL(dirName: String, fileName: String) -> URL? {
  let fm = FileManager.default
  let documentsURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
  let dirURL = documentsURL.appendingPathComponent(dirName)
  
  do {
    try fm.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
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
    print("Error encoding topic: \(error)")
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
      //json!.prettyPrintJSON()
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
