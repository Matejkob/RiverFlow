import SwiftUI
import Domain
import DomainStyling
import SwiftUINavigation
import TaskFeature

public struct TaskListView: View {
  @ObservedObject private var viewModel: TaskListViewModel
  
  public init(viewModel: TaskListViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    NavigationStack {
      List(viewModel.tasks) { task in
        Button {
          viewModel.taskTapped(task)
        } label: {
          TaskRowView(task: task)
        }
      }
      .navigationTitle("Tasks")
      .toolbar { toolbarContent }
      .sheet(item: $viewModel.destination.add) { task in
        TaskView(
          viewModel: TaskViewModel(
            task: task,
            onSave: { taskToSave in
              viewModel.saveNewTaskButtonTapped(task)
            },
            onCancel: {
              viewModel.cancelAddingNewTaskButtonTapped()
            }
          ),
          mode: .add
        )
      }
      .animation(.default, value: viewModel.tasks)
    }
  }
  
  @ToolbarContentBuilder
  private var toolbarContent: some ToolbarContent {
    ToolbarItem(placement: .automatic) {
      Button("Add new") {
        viewModel.addNewButtonTapped()
      }
    }
  }
}

#Preview {
  TaskListView(
    viewModel: TaskListViewModel(
      tasks: [
        TaskState(
          id: UUID(),
          name: "name 1",
          priorityLevel: .high,
          status: .inProgress,
          dueDate: Date() + 20
        ),
        TaskState(
          id: UUID(),
          name: "name 2",
          priorityLevel: .medium,
          status: .inProgress,
          dueDate: Date() + 20
        ),
        TaskState(
          id: UUID(),
          name: "name 3",
          priorityLevel: .low,
          status: .inProgress,
          dueDate: Date() + 20
        )
      ]
    )
  )
}
