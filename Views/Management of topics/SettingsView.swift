//
//  SettingsView.swift
//  MyRecallApp_v3
//
//  Created by Robert Goedman on 2/13/25.
//

import SwiftUI

struct SettingsView: View {
  @AppStorage(wrappedValue: "MyRecallApp/Data", .settingsDirNameKey)
  private var dirName: String
  
  @AppStorage(wrappedValue: "10", .settingsTimeStampsKey)
  private var noOfTimeStampsString: String
  
  @State private var showSettingsSheet = false
}

extension SettingsView {
  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField("Name", text: $dirName)
        } header: {
          Text("Application data directory")
        }
        Section {
          TextField("No of time stamps", text: $noOfTimeStampsString)
        } header: {
          Text("Number of recall time stamps to store")
        }
      }
      .navigationBarTitle("User Settings")
    }
  }
}

extension String {
  static var settingsDirNameKey : String { "settings.dirName" }
  static var settingsTimeStampsKey : String { "settings.noOfTimeStamps" }
}

#Preview {
  SettingsView()
}
