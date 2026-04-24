# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MyRecallApp is a spaced-repetition learning tool with two components:
- **MyRecallApp_v3.swift/** — SwiftUI iOS/macOS client using SwiftData + CloudKit
- **MyRecallAppService/** — Vapor HTTP backend (sibling directory, separate git repo)

## Build & Test Commands

**iOS/macOS App:**
```bash
# Build
xcodebuild -scheme MyRecallApp -destination 'platform=iOS Simulator,name=iPhone 16' build

# Run tests
xcodebuild test -scheme MyRecallApp -destination 'platform=iOS Simulator,name=iPhone 16'

# Run a single test
xcodebuild test -scheme MyRecallApp -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:MyRecallAppTests/MyRecallAppTests/testTopicEncoding
```

**Backend Service** (from `../MyRecallAppService/`):
```bash
swift build
swift run
```

## Architecture

### Data Model Hierarchy
```
Topic → SubTopic → Question
```
Each level has associated `RecallTimestamp` and `OnlineLink` models. All models use SwiftData (`@Model`) and are `Codable` for JSON serialization. Questions have an `includedInRecall` flag that controls whether they appear in recall sessions.

### Persistence
- **SwiftData** for local storage with CloudKit sync (configured in `MyRecallAppApp.swift` via `modelContainer`)
- **Remote JSON** via the Vapor backend: each topic is stored as `{topic}.json` in `~/Documents/MyRecallApp/Data/{user}/` on the server

### Backend API (OpenAPI-generated)
Both client and server code is generated from `openapi.yaml`. The backend runs on port `8083`.

| Endpoint | Purpose |
|----------|---------|
| `GET /pjson` | Save topic JSON (params: `user`, `topic`, `content`) |
| `GET /list` | List topics for a user (param: `user`) |
| `GET /gjson` | Retrieve topic JSON (params: `user`, `topic`) |

### App Configuration (UserDefaults via `@AppStorage`)
- `urlPath` — Backend URL, default: `http://Rob-Work-M3.local:8083/api`
- `defaultUser` — Username for remote storage, default: `Rob`
- `remote` — Toggle for remote vs local mode
- `dirName` — Local storage directory
- `noOfTimeStampsString` — Number of recall timestamps to retain

### Key Views
- `TopicListView` — Root view; launches recall sessions
- `QuestionAndUserAnswerView` — Quiz interface
- `JSONRemoteImportView` / `ManageTopicsView` — Remote/local topic import and management

### OpenAPI Code Generation
Both the app target and backend use `swift-openapi-generator`. If you modify `openapi.yaml`, regenerate the client/server stubs by building the respective target — generation runs as a build plugin automatically.
