import SwiftUI
import Domain
import DomainStyling
import SwiftUINavigation

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
        
        reminderTimeSection
          .disabled(!viewModel.notificationEnabled)
      }
      #if !os(macOS)
      .navigationBarTitleDisplayMode(.inline)
      #endif
      .navigationTitle(navigationTitle)
      .toolbar { toolbarContent }
      .alert(
        item: $viewModel.destination.validationAlert,
        title: { _ in Text("Validation error") },
        actions: { _ in
          Button("Cancel") { viewModel.cancelValidationAlertButtonTapped() }
        },
        message: { validationResultMessage in
          Text(validationResultMessage)
        }
      )
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
  
  // MARK: - Reminder Time Section
  
  private var reminderTimeSection: some View {
    Section("Reminder") {
      VStack {
        Toggle(
          "Enable Reminder",
          isOn: Binding(
            get: { viewModel.reminderTimeEnabled },
            set: { viewModel.reminderTimeToggled(to: $0) }
          )
        )
        
        if viewModel.reminderTimeEnabled {
          Picker(
            "Reminder Time",
            selection: Binding(
              get: { viewModel.task.reminderTime ?? 1 },
              set: { viewModel.reminderTimeChanged(to: $0) }
            )
          ) {
            ForEach(1..<16) { minute in
              Text("\(minute) minute\(minute == 1 ? "" : "s") before")
                .tag(TimeInterval(minute))
            }
          }
          .pickerStyle(.wheel)
        }
      }
    }
  }
  
  // MARK: - Toolbar
  
  @ToolbarContentBuilder
  private var toolbarContent: some ToolbarContent {
    ToolbarItem(placement: .confirmationAction) {
      Button("Save") {
        Task { await viewModel.saveButtonTapped() }
      }
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
        reminderTime: nil,
        dueDate: Date() + 60 * 60,
        creationDate: Date(),
        category: TaskCategory(id: UUID(), name: "Work")
      ),
      onSave: { _ in },
      onCancel: { }
    ),
    mode: .add
  )
}
