//
//  MyButton.swift
//  MyRecallApp_v3
//
//  Created by Robert Goedman on 9/12/25.
//

import SwiftUI

struct MRAButton: View {
  var label: String
  var isDisabled: Bool = false
  var action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Text(label)
        .disabled(isDisabled)
        .padding() // Add padding around the text
        .background(isDisabled ? Color.gray : Color.blue)
        .foregroundColor(.white) // Set the text color
        .font(.headline) // Set the font style
        .cornerRadius(10) // Round the corners
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .multilineTextAlignment(TextAlignment.center)
        //.liquidGlass(material: .regular)
    }
  }
}

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}
