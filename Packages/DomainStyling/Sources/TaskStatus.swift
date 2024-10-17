import Domain
import SwiftUI

extension TaskStatus {
  public var name: String {
    switch self {
    case .pending:
      "Pending"
    case .inProgress:
      "In Progress"
    case .completed:
      "Completed"
    }
  }

  public var icon: Image {
    switch self {
    case .pending:
      Image(systemName: "clock")
    case .inProgress:
      Image(systemName: "arrow.triangle.2.circlepath.circle")
    case .completed:
      Image(systemName: "checkmark.circle")
    }
  }
  
  public var color: Color {
    switch self {
    case .pending:
      .gray
    case .inProgress:
      .blue
    case .completed:
      .green
    }
  }
}
