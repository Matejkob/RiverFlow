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
      List {
        ForEach(viewModel.filteredTasks) { task in
          Button {
            viewModel.taskTapped(task)
          } label: {
            TaskRowView(task: task)
          }
        }
        .onDelete { index in
          viewModel.deleteTask(at: index)
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
      .sheet(item: $viewModel.destination.edit) { task in
        TaskView(
          viewModel: TaskViewModel(
            task: task,
            onSave: { taskToUpdate in
              viewModel.updateTaskButtonTapped(taskToUpdate)
            },
            onCancel: {
              viewModel.cancelEditingTaskButtonTapped()
            }
          ),
          mode: .edit
        )
      }
      .animation(.default, value: viewModel.filteredTasks)
    }
  }
  
  @ToolbarContentBuilder
  private var toolbarContent: some ToolbarContent {
    ToolbarItem(placement: .automatic) {
      Button {
        viewModel.addNewButtonTapped()
      } label: {
        Text("Add")
      }
    }
    
    ToolbarItem(placement: .automatic) {
      Menu {
        Menu("Sorting") {
          Picker(
            "Sorting",
            selection: Binding(
              get: { viewModel.selectedSortOrder },
              set: { viewModel.changeSortOrder(to: $0) }
            )
          ) {
            ForEach(TaskSortOrder.allCases) { sortOrder in
              Text(sortOrder.name)
            }
          }
        }
        Menu("Filtering") {
          Picker(
            "Filtering",
            selection: Binding(
              get: { viewModel.selectedPriorityLevelFilter },
              set: { viewModel.changePriorityLevelFilter(to: $0) }
            )
          ) {
            Text("All")
              .tag(Optional<TaskPiorityLevel>.none)
            
            ForEach(TaskPiorityLevel.allCases) { piorityLevel in
              Text(piorityLevel.name)
                .tag(Optional<TaskPiorityLevel>.some(piorityLevel))
            }
          }
        }
      } label: {
        Image(systemName: "line.3.horizontal.decrease.circle")
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
          dueDate: Date() + 60,
          creationDate: Date()
        ),
        TaskState(
          id: UUID(),
          name: "name 2",
          priorityLevel: .medium,
          status: .inProgress,
          dueDate: Date() + 60 * 2,
          creationDate: Date()
        ),
        TaskState(
          id: UUID(),
          name: "name 3",
          priorityLevel: .low,
          status: .inProgress,
          dueDate: Date() + 60 * 3,
          creationDate: Date()
        )
      ]
    )
  )
}
