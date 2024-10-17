import SwiftUI
import Domain
import DomainStyling

public struct TaskView: View {
  public enum Mode {
    case add
    case edit
  }
  
  @ObservedObject private var viewModel: TaskViewModel
  private let mode: Mode
  
  public init(
    viewModel: TaskViewModel,
    mode: Mode
  ) {
    self.viewModel = viewModel
    self.mode = mode
  }
  
  public var body: some View {
    NavigationStack {
      Form {
        nameSection
        
        prioritySection
        
        statusSection
        
        dueDateSection
      }
      #if !os(macOS)
      .navigationBarTitleDisplayMode(.inline)
      #endif
      .navigationTitle(navigationTitle)
      .toolbar { toolbarContent }
    }
  }
  
  // MARK: - Sections
  
  private var nameSection: some View {
    Section("Name") {
      TextField(
        text: Binding(
          get: { viewModel.task.name },
          set: { viewModel.nameChanged(to: $0) }
        )
      ) {
        Text("Enter task name")
      }
    }
  }
  
  private var prioritySection: some View {
    Section("Priority") {
      Picker(
        "Choose a priority",
        selection: Binding(
          get: { viewModel.task.priorityLevel },
          set: { viewModel.priorityLevelChanged(to: $0) }
        )
      ) {
        ForEach(TaskPiorityLevel.allCases) { piorityLevel in
          Text(piorityLevel.name)
        }
      }
      .pickerStyle(.segmented)
    }
  }
  
  private var statusSection: some View {
    Section("Status") {
      HStack {
        Text(viewModel.task.status.name)
        Spacer()
        viewModel.task.status.icon
      }
    }
  }
  
  private var dueDateSection: some View {
    Section("Due Date") {
      DatePicker(
        "Due Date",
        selection: Binding(
          get: { viewModel.task.dueDate },
          set: { viewModel.dueDateChanged(to: $0) }
        )
      )
    }
  }
  
  // MARK: - Toolbar
  
  @ToolbarContentBuilder
  private var toolbarContent: some ToolbarContent {
    ToolbarItem(placement: .confirmationAction) {
      Button("Save", action: viewModel.saveButtonTapped)
    }
    
    ToolbarItem(placement: .cancellationAction) {
      Button("Cancel", action: viewModel.cancelButtonTapped)
    }
  }
  
  private var navigationTitle: String {
    switch mode {
    case .add: return "Add New Task"
    case .edit: return "Edit Task"
    }
  }
}

#Preview {
  TaskView(
    viewModel: TaskViewModel(
      task: TaskState(
        id: UUID(),
        name: "Finish todo app",
        priorityLevel: .high,
        status: .inProgress,
        dueDate: Date() + 60 * 60,
        creationDate: Date()
      ),
      onSave: { _ in },
      onCancel: { }
    ),
    mode: .add
  )
}
