//
//  JSONImportAndExport.swift
//  MyRecallApp
//
//  Created by Robert Goedman on 1/27/25.
//

import Foundation

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
