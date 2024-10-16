import Domain
import SwiftUI

extension TaskPiorityLevel {
  public var name: String {
    switch self {
    case .low:
      "Low"
    case .medium:
      "Medium"
    case .high:
      "High"
    }
  }
  
  public var color: Color {
    switch self {
    case .low:
        .blue
    case .medium:
        .orange
    case .high:
        .red
    }
  }
}
