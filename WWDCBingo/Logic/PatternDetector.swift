import Foundation

struct PatternDetector {
    
    // MARK: - Main Detection Method
    
    /// Detects all winning patterns in the current game state
    /// - Parameter selectedPositions: Set of currently selected grid positions
    /// - Returns: Array of WinningPattern objects for all detected patterns
    static func detectWinningPatterns(selectedPositions: Set<GridPosition>) -> [WinningPattern] {
        var patterns: [WinningPattern] = []
        
        // Check horizontal patterns (rows)
        patterns.append(contentsOf: detectHorizontalPatterns(selectedPositions: selectedPositions))
        
        // Check vertical patterns (columns)
        patterns.append(contentsOf: detectVerticalPatterns(selectedPositions: selectedPositions))
        
        // Check diagonal patterns
        patterns.append(contentsOf: detectDiagonalPatterns(selectedPositions: selectedPositions))
        
        return patterns
    }
    
    // MARK: - Horizontal Pattern Detection
    
    /// Detects winning horizontal lines (complete rows)
    private static func detectHorizontalPatterns(selectedPositions: Set<GridPosition>) -> [WinningPattern] {
        var patterns: [WinningPattern] = []
        
        // Check each row (0-4)
        for row in 0..<5 {
            let rowPositions = (0..<5).map { column in
                GridPosition(row: row, column: column)
            }
            
            // Check if all positions in this row are selected
            if rowPositions.allSatisfy({ selectedPositions.contains($0) }) {
                let pattern = WinningPattern(
                    type: .horizontal(row: row),
                    positions: rowPositions
                )
                patterns.append(pattern)
            }
        }
        
        return patterns
    }
    
    // MARK: - Vertical Pattern Detection
    
    /// Detects winning vertical lines (complete columns)
    private static func detectVerticalPatterns(selectedPositions: Set<GridPosition>) -> [WinningPattern] {
        var patterns: [WinningPattern] = []
        
        // Check each column (0-4)
        for column in 0..<5 {
            let columnPositions = (0..<5).map { row in
                GridPosition(row: row, column: column)
            }
            
            // Check if all positions in this column are selected
            if columnPositions.allSatisfy({ selectedPositions.contains($0) }) {
                let pattern = WinningPattern(
                    type: .vertical(column: column),
                    positions: columnPositions
                )
                patterns.append(pattern)
            }
        }
        
        return patterns
    }
    
    // MARK: - Diagonal Pattern Detection
    
    /// Detects winning diagonal lines (both main diagonals)
    private static func detectDiagonalPatterns(selectedPositions: Set<GridPosition>) -> [WinningPattern] {
        var patterns: [WinningPattern] = []
        
        // Check main diagonal (top-left to bottom-right)
        let mainDiagonalPositions = (0..<5).map { GridPosition(row: $0, column: $0) }
        if mainDiagonalPositions.allSatisfy({ selectedPositions.contains($0) }) {
            patterns.append(WinningPattern(
                type: .diagonalMain,
                positions: mainDiagonalPositions
            ))
        }
        
        // Check anti-diagonal (top-right to bottom-left)
        let antiDiagonalPositions = (0..<5).map { GridPosition(row: $0, column: 4 - $0) }
        if antiDiagonalPositions.allSatisfy({ selectedPositions.contains($0) }) {
            patterns.append(WinningPattern(
                type: .diagonalAnti,
                positions: antiDiagonalPositions
            ))
        }
        
        return patterns
    }
    
    // MARK: - Utility Methods
    
    /// Checks if a specific pattern type exists in the selected positions
    /// - Parameters:
    ///   - patternType: The type of pattern to check for
    ///   - selectedPositions: Set of currently selected positions
    /// - Returns: True if the pattern exists, false otherwise
    static func hasPattern(type patternType: WinningPattern.PatternType, 
                          selectedPositions: Set<GridPosition>) -> Bool {
        let patterns = detectWinningPatterns(selectedPositions: selectedPositions)
        return patterns.contains { $0.type == patternType }
    }
    
    /// Returns the total number of winning patterns detected
    static func winningPatternCount(selectedPositions: Set<GridPosition>) -> Int {
        return detectWinningPatterns(selectedPositions: selectedPositions).count
    }
    
    /// Checks if any winning pattern exists
    static func hasAnyWinningPattern(selectedPositions: Set<GridPosition>) -> Bool {
        return !detectWinningPatterns(selectedPositions: selectedPositions).isEmpty
    }
}

// MARK: - Pattern Validation Extensions
extension PatternDetector {
    
    /// Validates that all positions in a potential pattern are within grid bounds
    private static func isValidPattern(positions: [GridPosition]) -> Bool {
        return positions.allSatisfy { $0.isValid }
    }
    
    /// Returns a description of all detected patterns for debugging
    static func patternDescription(selectedPositions: Set<GridPosition>) -> String {
        let patterns = detectWinningPatterns(selectedPositions: selectedPositions)
        
        if patterns.isEmpty {
            return "No winning patterns detected"
        }
        
        let descriptions = patterns.map { pattern in
            "\(pattern.type.displayName): \(pattern.positions.map { "(\($0.row),\($0.column))" }.joined(separator: ", "))"
        }
        
        return "Winning patterns: \(descriptions.joined(separator: "; "))"
    }
} 