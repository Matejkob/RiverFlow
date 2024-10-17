import Domain
import Foundation

public protocol UserPreferencesRepository {
  var selectedSortOrder: TaskSortOrder { get set }
  var selectedPriorityLevelFilter: TaskPiorityLevel? { get set }
  var selectedCategoryFilterId: UUID? { get set }
  var notificationsEnabled: Bool { get set }
}
