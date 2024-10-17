import Domain

public protocol TaskRepository: Sendable {
  func fetchAllTasks(
    sortBy: TaskSortOrder,
    filterBy: TaskPiorityLevel?
  ) async throws -> [TaskState]
  func fetchAllCategories() async throws -> [TaskCategory]
  func fetchTasks(
    for category: TaskCategory,
    sortBy: TaskSortOrder,
    filterBy: TaskPiorityLevel?
  ) async throws -> [TaskState]
  func saveTask(_ task: TaskState) async throws
  func saveCategory(_ category: TaskCategory) async throws
  func updateTask(_ task: TaskState) async throws
  func deleteTask(_ task: TaskState) async throws
}
