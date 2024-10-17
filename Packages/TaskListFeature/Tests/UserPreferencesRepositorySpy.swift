@testable import Domain
import Foundation
@testable import UserPreferencesRepository

class UserPreferencesRepositorySpy: UserPreferencesRepository {
  // MARK: - Selected Sort Order
  
  var selectedSortOrderGetCallCount = 0
  var selectedSortOrderSetCallCount = 0
  var receivedSelectedSortOrder: TaskSortOrder?
  var selectedSortOrderStub: TaskSortOrder = .creationDateAscending
  
  var selectedSortOrder: TaskSortOrder {
    get {
      selectedSortOrderGetCallCount += 1
      return selectedSortOrderStub
    }
    set {
      selectedSortOrderSetCallCount += 1
      receivedSelectedSortOrder = newValue
      selectedSortOrderStub = newValue
    }
  }
  
  // MARK: - Selected Priority Level Filter
  
  var selectedPriorityLevelFilterGetCallCount = 0
  var selectedPriorityLevelFilterSetCallCount = 0
  var receivedSelectedPriorityLevelFilter: TaskPiorityLevel?
  var selectedPriorityLevelFilterStub: TaskPiorityLevel? = nil
  
  var selectedPriorityLevelFilter: TaskPiorityLevel? {
    get {
      selectedPriorityLevelFilterGetCallCount += 1
      return selectedPriorityLevelFilterStub
    }
    set {
      selectedPriorityLevelFilterSetCallCount += 1
      receivedSelectedPriorityLevelFilter = newValue
      selectedPriorityLevelFilterStub = newValue
    }
  }
  
  // MARK: - Selected Category Filter Id
  
  var selectedCategoryFilterIdSetCallCount = 0
  var selectedCategoryFilterIdGetCallCount = 0
  var receivedSelectedCategoryFilterId: UUID?
  var selectedCategoryFilterIdStub: UUID? = nil
  
  var selectedCategoryFilterId: UUID? {
    get {
      selectedCategoryFilterIdGetCallCount += 1
      return selectedCategoryFilterIdStub
    }
    set {
      selectedCategoryFilterIdSetCallCount += 1
      receivedSelectedCategoryFilterId = newValue
      selectedCategoryFilterIdStub = newValue
    }
  }
}

extension UserPreferencesRepository where Self == UserPreferencesRepositorySpy {
  static var spy: Self { UserPreferencesRepositorySpy() }
}
