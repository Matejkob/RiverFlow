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
    case .removed:
      "Removed"
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
    case .removed:
      Image(systemName: "trash")
    }
  }
  
  public var color: Color {
    switch self {
    case .pending:
      .yellow
    case .inProgress:
      .blue
    case .completed:
      .green
    case .removed:
      .red
    }
  }
}
