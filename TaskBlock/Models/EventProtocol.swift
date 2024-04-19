import Foundation

// Set debug logging flag here
public var debug = false

// Define a blueprint that our tasks, blocks, and days can conform to
protocol Event {
    var id: Int { get set }
    var title: String? { get set }
    var duration: TimeInterval { get }
}

// Define the Difficulty enum here, as both the Task and Block classes use it
enum Difficulty {
    case low, medium, high
}

enum Size {
    case small, medium, large, extraLarge
}

enum Priority: CaseIterable {
    case low, medium, high
}
