import Testing
@testable import RiverFlow
import UserPreferencesRepository
import Domain
import Foundation

@MainActor
@Suite("RiverFlow App Model Unit Tests")
struct RiverFlowAppModelTests {
  @Test func testRequestNotificationPermission_Success() async {
    let mockUserPreferencesRepository = MockUserPreferencesRepository()
    let mockRequestNotificationAuthorization: () async throws -> Bool = {
      return true
    }
    
    let sut = RiverFlowAppModel(
      requestNotificationAuthorization: mockRequestNotificationAuthorization,
      userPreferencesRepository: mockUserPreferencesRepository
    )
    
    await sut.requestNotificationPermission()
    
    #expect(mockUserPreferencesRepository.notificationsEnabled == true)
  }
  
  @Test func testRequestNotificationPermission_Failure() async {
    // Arrange: Create a mock repository and a mock closure that throws an error
    let mockUserPreferencesRepository = MockUserPreferencesRepository()
    let mockRequestNotificationAuthorization: () async throws -> Bool = {
      throw NSError(domain: "TestError", code: 1, userInfo: nil)
    }
    
    let sut = RiverFlowAppModel(
      requestNotificationAuthorization: mockRequestNotificationAuthorization,
      userPreferencesRepository: mockUserPreferencesRepository
    )
    
    await sut.requestNotificationPermission()
    
    #expect(mockUserPreferencesRepository.notificationsEnabled == false)
  }
}

// A simple mock implementation of the UserPreferencesRepository for testing purposes
fileprivate class MockUserPreferencesRepository: UserPreferencesRepository {
  var selectedSortOrder: TaskSortOrder = .creationDateAscending
  var selectedPriorityLevelFilter: TaskPiorityLevel?
  var selectedCategoryFilterId: UUID?
  var notificationsEnabled: Bool = false
}
