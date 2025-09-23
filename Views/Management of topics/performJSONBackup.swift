//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftOpenAPIGenerator open source project
//
// Copyright (c) 2023 Apple Inc. and the SwiftOpenAPIGenerator project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftOpenAPIGenerator project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

/// A content view that can make HTTP requests to the GreetingService
/// running on localhost to fetch customized greetings.
///
/// By default, it makes live network calls, but it can be provided
/// with `MockClient` to make mocked in-memory calls only, which is more
/// appropriate in previews and tests.

struct PerformJSONBackup: View {
  @State private var user: String = "Stranger!"
  @State private var topic: String = "Chemistry"
  @State private var content: String = "Hi there"
  @State private var result: String = "No response yet"
  
  let client: any APIProtocol
  init(client: any APIProtocol) { self.client = client }
  init() {
    self.init(
      client: Client(serverURL: URL(string: "http://Rob-Work-M3.local:8080/api")!,
                     transport: URLSessionTransport())
    )
  }
  func updateTopic() async {
    do {
      let response = try await client.putJson(
        query: .init(user: user,
                     topic: topic,
                     content: content))
      result = try response.ok.body.json.message
    } catch { result = "Error: \(error.localizedDescription)" }
  }
  var body: some View {
    VStack {
      Image(systemName: "globe").imageScale(.large)
      Text(result).accessibilityIdentifier("greeting-label")
      Spacer()
      Text("Enter a topic:").fontWeight(.bold)
      TextField("Topic", text: $topic)
        .padding(.horizontal)
        .multilineTextAlignment(.center)
      Spacer()
      Text("Enter your name:").fontWeight(.bold)
      TextField("User", text: $user)
        .padding(.horizontal)
        .multilineTextAlignment(.center)
      Spacer()
      Button("Send JSON") { Task { await updateTopic() } }
    }
    .padding().buttonStyle(.borderedProminent).font(.system(size: 20))
  }
}
