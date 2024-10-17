import SwiftUI
import Domain
import DomainStyling
import SwiftUINavigation
import TaskFeature
import InMemoryTaskRepository
import DefaultUserPreferencesRepository

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
          Task { await viewModel.deleteTask(at: index) }
        }
      }
      .navigationTitle("Tasks")
      .toolbar { toolbarContent }
      .sheet(item: $viewModel.destination.add) { task in
        TaskView(
          viewModel: TaskViewModel(
            task: task,
            onSave: { taskToSave in
              await viewModel.saveNewTaskButtonTapped(taskToSave)
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
              await viewModel.updateTaskButtonTapped(taskToUpdate)
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
    .task {
      await viewModel.onAppear()
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
              set: { newValue in
                Task { await viewModel.changeSortOrder(to: newValue) }
              }
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
              set: { newValue in
                Task { await viewModel.changePriorityLevelFilter(to: newValue)}
              }
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
      taskRepository: .inMemory,
      userPreferencesRepository: .userDefaults
    )
  )
}
