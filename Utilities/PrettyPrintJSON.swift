//
//  PrettyPrintJSON.swift
//  MyRecallApp_v3
//
//  Created by Robert Goedman on 9/1/25.
//

import Foundation

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
