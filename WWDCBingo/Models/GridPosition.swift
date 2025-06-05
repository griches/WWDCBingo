import Foundation

struct GridPosition: Hashable, Codable {
    let row: Int
    let column: Int
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    
    // Convert linear index (0-24) to grid position
    init(index: Int) {
        self.row = index / 5
        self.column = index % 5
    }
    
    // Convert grid position to linear index (0-24)
    var index: Int {
        return row * 5 + column
    }
    
    // Validation
    var isValid: Bool {
        return row >= 0 && row < 5 && column >= 0 && column < 5
    }
}

// MARK: - Convenience Extensions
extension GridPosition {
    static let zero = GridPosition(row: 0, column: 0)
    static let center = GridPosition(row: 2, column: 2)
    
    // All positions in a 5x5 grid
    static var allPositions: [GridPosition] {
        var positions: [GridPosition] = []
        for row in 0..<5 {
            for column in 0..<5 {
                positions.append(GridPosition(row: row, column: column))
            }
        }
        return positions
    }
} 