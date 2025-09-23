//
//  SettingsView.swift
//  MyRecallApp_v3
//
//  Created by Robert Goedman on 2/13/25.
//

import SwiftUI

struct SettingsView: View {
  @AppStorage("dirName") private var dirName = "MyRecallApp/Data"
  @AppStorage("noOfTimeStampsString") private var noOfTimeStampsString = "10"
  @AppStorage("remote") private var remote = "true"
  @AppStorage("defaultUser") private var defaultUser = "Rob"
  @AppStorage("urlPath") private var urlPath = serverPath

  @State private var showSettingsSheet = false
  @State private var isHelpScreenShown = false
  
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss

}

extension SettingsView {
  var body: some View {
    NavigationStack {
      Form {
        HStack {
          Spacer()
          Text(LocalizedStringResource(stringLiteral: "App settings"))
            .font(.title.bold())
            .padding(.horizontal)
            .foregroundStyle(.blue)
          Spacer()
        }
        Section {
          TextField("Name", text: $dirName)
        } header: {
          Text("Application data directory:")
        }
        Section {
          TextField("No of time stamps", text: $noOfTimeStampsString)
        } header: {
          Text("Number of recall time stamps to store:")
        }
        Section {
          TextField("Backup to remote", text: $remote)
        } header: {
          Text("Backups remote?")
        }
        Section {
          TextField("Default user name", text: $defaultUser)
        } header: {
          Text("Default user name:")
        }
        Section {
          TextField("New server URL", text: $urlPath)
          Text("Current server URL path:\n\(serverPath)")
            .multilineTextAlignment(.center)
            .fontWeight(.light)
            .foregroundStyle(.red)
        } header: {
          Text("New server URL path:")
        }
      }
      .fontWeight(.semibold)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            dismiss()
          } label: {
            Label("less than", systemImage: "lessthan")
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isHelpScreenShown = true
          } label: {
            Label("Help", systemImage: "questionmark")
          }
        }
      }
    }
    .onDisappear {
      UserDefaults.standard.set(dirName, forKey: "dirName")
      UserDefaults.standard.set(noOfTimeStampsString, forKey: "noOfTimeStampsString")
      UserDefaults.standard.set(remote, forKey: "remote")
      UserDefaults.standard.set(defaultUser, forKey: "defaultUser")
      UserDefaults.standard.set(urlPath, forKey: "urlPath")
      serverPath = urlPath
    }
    .sheet(isPresented: $isHelpScreenShown) {
      SettingsViewHelpScreen()
    }

  }
}

#Preview {
  SettingsView()
}
