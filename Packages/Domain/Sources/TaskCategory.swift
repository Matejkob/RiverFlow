import Foundation

public struct TaskCategory: Equatable, Hashable, Identifiable, Sendable {
    public let id: UUID
    public let name: String
    
    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
