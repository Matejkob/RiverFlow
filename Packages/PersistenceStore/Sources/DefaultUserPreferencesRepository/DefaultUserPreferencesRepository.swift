import Foundation
import UserPreferencesRepository
import Domain

public final class DefaultUserPreferencesRepository: UserPreferencesRepository {
  // Keys for storing data in UserDefaults
  private enum Keys {
    static let selectedSortOrder = "selectedSortOrder"
    static let selectedPriorityLevelFilter = "selectedPriorityLevelFilter"
    static let selectedCategoryFilterId = "selectedCategoryFilterID"
    static let notificationsEnabled = "notificationsEnabled"
  }
  
  private let userDefaults: UserDefaults
  
  public init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
  
  public var selectedSortOrder: TaskSortOrder {
    get {
      if let rawValue = userDefaults.string(forKey: Keys.selectedSortOrder),
         let sortOrder = TaskSortOrder(rawValue: rawValue) {
        return sortOrder
      }
      return .creationDateAscending // Default value
    }
    set {
      userDefaults.set(newValue.rawValue, forKey: Keys.selectedSortOrder)
    }
  }
  
  public var selectedPriorityLevelFilter: TaskPiorityLevel? {
    get {
      guard let rawValue = userDefaults.string(forKey: Keys.selectedPriorityLevelFilter),
              let int = Int(rawValue) else {
        return nil
      }
      return TaskPiorityLevel(rawValue: int)
    }
    set {
      userDefaults.set(newValue?.rawValue, forKey: Keys.selectedPriorityLevelFilter)
    }
  }
  
  public var selectedCategoryFilterId: UUID? {
    get {
      guard let idString = userDefaults.string(forKey: Keys.selectedCategoryFilterId),
            let id = UUID(uuidString: idString) else {
        return nil
      }
      return id
    }
    set {
      userDefaults.set(newValue?.uuidString, forKey: Keys.selectedCategoryFilterId)
    }
  }
  
  public var notificationsEnabled: Bool {
    get { userDefaults.bool(forKey: Keys.notificationsEnabled) }
    set { userDefaults.set(newValue, forKey: Keys.notificationsEnabled) }
  }
}

extension UserPreferencesRepository where Self == DefaultUserPreferencesRepository {
  public static var userDefaults: Self { DefaultUserPreferencesRepository() }
}
