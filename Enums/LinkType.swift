enum LinkType: String, Codable, Identifiable, CaseIterable, CustomStringConvertible {
  case website = "Website"
  case wikipedia = "Wikipedia"
  case github = "GitHub"
  case spanish = "Spanish Wikipedia"
  case huberman = "Huberman Lab"
  case biochemistry = "Biochemistry Wiki"
  //case externalLink = "External Link"
  case internalLink = "Internal Link"
}

extension LinkType {
  var description: String {
    rawValue
  }
}

extension LinkType {
  var id: Self {
    self
  }
}
