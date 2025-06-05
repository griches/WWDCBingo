import Foundation

/// Test utilities for PatternDetector - for development validation
/// Note: In a production app, these would be in a separate test target
struct PatternDetectorTests {
    
    // MARK: - Test Runners
    
    /// Runs all pattern detection tests
    static func runAllTests() -> Bool {
        print("🧪 Running Pattern Detection Tests...")
        
        let tests = [
            testHorizontalPatterns(),
            testVerticalPatterns(),
            testDiagonalPatterns(),
            testMultiplePatterns(),
            testNoPatterns(),
            testEdgeCases()
        ]
        
        let passedTests = tests.filter { $0 }.count
        let totalTests = tests.count
        
        print("✅ Pattern Detection Tests: \(passedTests)/\(totalTests) passed")
        return passedTests == totalTests
    }
    
    // MARK: - Horizontal Pattern Tests
    
    static func testHorizontalPatterns() -> Bool {
        print("Testing horizontal patterns...")
        
        // Test each row
        for row in 0..<5 {
            let positions = Set((0..<5).map { column in
                GridPosition(row: row, column: column)
            })
            
            let patterns = PatternDetector.detectWinningPatterns(selectedPositions: positions)
            
            guard patterns.count == 1,
                  patterns.first?.type == .horizontal else {
                print("❌ Failed horizontal test for row \(row)")
                return false
            }
        }
        
        print("✅ Horizontal patterns test passed")
        return true
    }
    
    // MARK: - Vertical Pattern Tests
    
    static func testVerticalPatterns() -> Bool {
        print("Testing vertical patterns...")
        
        // Test each column
        for column in 0..<5 {
            let positions = Set((0..<5).map { row in
                GridPosition(row: row, column: column)
            })
            
            let patterns = PatternDetector.detectWinningPatterns(selectedPositions: positions)
            
            guard patterns.count == 1,
                  patterns.first?.type == .vertical else {
                print("❌ Failed vertical test for column \(column)")
                return false
            }
        }
        
        print("✅ Vertical patterns test passed")
        return true
    }
    
    // MARK: - Diagonal Pattern Tests
    
    static func testDiagonalPatterns() -> Bool {
        print("Testing diagonal patterns...")
        
        // Test main diagonal (top-left to bottom-right)
        let mainDiagonalPositions = Set((0..<5).map { index in
            GridPosition(row: index, column: index)
        })
        
        let mainDiagonalPatterns = PatternDetector.detectWinningPatterns(selectedPositions: mainDiagonalPositions)
        
        guard mainDiagonalPatterns.count == 1,
              mainDiagonalPatterns.first?.type == .diagonalTopLeftToBottomRight else {
            print("❌ Failed main diagonal test")
            return false
        }
        
        // Test anti-diagonal (top-right to bottom-left)
        let antiDiagonalPositions = Set((0..<5).map { index in
            GridPosition(row: index, column: 4 - index)
        })
        
        let antiDiagonalPatterns = PatternDetector.detectWinningPatterns(selectedPositions: antiDiagonalPositions)
        
        guard antiDiagonalPatterns.count == 1,
              antiDiagonalPatterns.first?.type == .diagonalTopRightToBottomLeft else {
            print("❌ Failed anti-diagonal test")
            return false
        }
        
        print("✅ Diagonal patterns test passed")
        return true
    }
    
    // MARK: - Multiple Pattern Tests
    
    static func testMultiplePatterns() -> Bool {
        print("Testing multiple patterns...")
        
        // Create positions that form both diagonals (X pattern)
        var positions = Set<GridPosition>()
        
        // Add main diagonal
        for index in 0..<5 {
            positions.insert(GridPosition(row: index, column: index))
        }
        
        // Add anti-diagonal
        for index in 0..<5 {
            positions.insert(GridPosition(row: index, column: 4 - index))
        }
        
        let patterns = PatternDetector.detectWinningPatterns(selectedPositions: positions)
        
        guard patterns.count == 2,
              patterns.contains(where: { $0.type == .diagonalTopLeftToBottomRight }),
              patterns.contains(where: { $0.type == .diagonalTopRightToBottomLeft }) else {
            print("❌ Failed multiple patterns test")
            return false
        }
        
        print("✅ Multiple patterns test passed")
        return true
    }
    
    // MARK: - No Pattern Tests
    
    static func testNoPatterns() -> Bool {
        print("Testing no patterns...")
        
        // Test empty selection
        let emptyPatterns = PatternDetector.detectWinningPatterns(selectedPositions: Set())
        guard emptyPatterns.isEmpty else {
            print("❌ Failed empty selection test")
            return false
        }
        
        // Test incomplete patterns
        let incompletePositions = Set([
            GridPosition(row: 0, column: 0),
            GridPosition(row: 0, column: 1),
            GridPosition(row: 0, column: 2),
            GridPosition(row: 0, column: 3)
            // Missing GridPosition(row: 0, column: 4) for complete horizontal
        ])
        
        let incompletePatterns = PatternDetector.detectWinningPatterns(selectedPositions: incompletePositions)
        guard incompletePatterns.isEmpty else {
            print("❌ Failed incomplete pattern test")
            return false
        }
        
        print("✅ No patterns test passed")
        return true
    }
    
    // MARK: - Edge Case Tests
    
    static func testEdgeCases() -> Bool {
        print("Testing edge cases...")
        
        // Test utility methods
        let positions = Set([GridPosition(row: 0, column: 0)])
        
        let hasAnyPattern = PatternDetector.hasAnyWinningPattern(selectedPositions: positions)
        guard !hasAnyPattern else {
            print("❌ Failed hasAnyWinningPattern test")
            return false
        }
        
        let patternCount = PatternDetector.winningPatternCount(selectedPositions: positions)
        guard patternCount == 0 else {
            print("❌ Failed winningPatternCount test")
            return false
        }
        
        // Test specific pattern type checking
        let horizontalPositions = Set((0..<5).map { column in
            GridPosition(row: 0, column: column)
        })
        
        let hasHorizontal = PatternDetector.hasPattern(type: .horizontal, selectedPositions: horizontalPositions)
        let hasVertical = PatternDetector.hasPattern(type: .vertical, selectedPositions: horizontalPositions)
        
        guard hasHorizontal && !hasVertical else {
            print("❌ Failed specific pattern type test")
            return false
        }
        
        print("✅ Edge cases test passed")
        return true
    }
    
    // MARK: - Performance Tests
    
    static func runPerformanceTest() {
        print("🚀 Running pattern detection performance test...")
        
        // Create a full grid selection (worst case)
        let allPositions = Set(GridPosition.allPositions)
        
        let startTime = Date()
        
        // Run detection multiple times
        for _ in 0..<1000 {
            _ = PatternDetector.detectWinningPatterns(selectedPositions: allPositions)
        }
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        print("⚡ 1000 pattern detections completed in \(String(format: "%.3f", duration))s")
        print("⚡ Average time per detection: \(String(format: "%.6f", duration / 1000))s")
    }
} 