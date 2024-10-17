import Domain
import SwiftUI
import DomainStyling

struct TaskRowView: View {
  let task: TaskState
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      taskNameView
      
      HStack {
        taskDateView
        Spacer()
        taskPriorityLevelView
      }
      
      HStack {
        taskStatusView
        Spacer()
        taskCategoryView
      }
    }
    .foregroundStyle(Color.primary)
  }
  
  private var taskNameView: some View {
    Text(task.name)
      .font(.headline)
  }
  
  private var taskDateView: some View {
    Text("Due: \(task.dueDate, formatter: dueDateFormatter)")
      .font(.subheadline)
      .foregroundColor(.gray)
  }
  
  private var taskPriorityLevelView: some View {
    Text(task.priorityLevel.name)
      .font(.subheadline)
      .foregroundStyle(task.priorityLevel.color)
  }
  
  private var taskStatusView: some View {
    HStack {
      Text(task.status.name)
        .font(.subheadline)
      task.status.icon
    }
    .foregroundStyle(task.status.color)
  }
  
  private var taskCategoryView: some View {
    if let category = task.category {
      Text(category.name)
        .font(.subheadline)
        .foregroundColor(.secondary)
    } else {
      Text("No Category")
        .font(.subheadline)
        .foregroundColor(.gray)
    }
  }
  
  private let dueDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
  }()
}

#Preview {
  List {
    TaskRowView(
      task: TaskState(
        id: UUID(),
        name: "Hire Mateusz Bąk",
        priorityLevel: .high,
        status: .inProgress,
        reminderTime: nil,
        dueDate: Date() + 60 * 60 * 4,
        creationDate: Date(),
        category: nil
      )
    )
    TaskRowView(
      task: TaskState(
        id: UUID(),
        name: "Hire Mateusz Bąk",
        priorityLevel: .medium,
        status: .pending,
        reminderTime: nil,
        dueDate: Date() + 60 * 60 * 4,
        creationDate: Date(),
        category: TaskCategory(id: UUID(), name: "Work")
      )
    )
    TaskRowView(
      task: TaskState(
        id: UUID(),
        name: "Hire Mateusz Bąk",
        priorityLevel: .low,
        status: .completed,
        reminderTime: nil,
        dueDate: Date() + 60 * 60 * 4,
        creationDate: Date(),
        category: TaskCategory(id: UUID(), name: "Personal")
      )
    )
  }
}
