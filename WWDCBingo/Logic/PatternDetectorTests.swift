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
        
        print("✅ Passed: \(passedTests)/\(totalTests) tests")
        return passedTests == totalTests
    }
    
    // MARK: - Individual Tests
    
    static func testHorizontalPatterns() -> Bool {
        print("Testing horizontal pattern detection...")
        
        // Test row 0 horizontal pattern
        let horizontalPositions: Set<GridPosition> = [
            GridPosition(row: 0, column: 0),
            GridPosition(row: 0, column: 1),
            GridPosition(row: 0, column: 2),
            GridPosition(row: 0, column: 3),
            GridPosition(row: 0, column: 4)
        ]
        
        let patterns = PatternDetector.detectWinningPatterns(selectedPositions: horizontalPositions)
        
        guard patterns.count == 1,
              case .horizontal(let row) = patterns.first?.type,
              row == 0 else {
            print("❌ Horizontal pattern test failed")
            return false
        }
        
        print("✅ Horizontal pattern test passed")
        return true
    }
    
    static func testVerticalPatterns() -> Bool {
        print("Testing vertical pattern detection...")
        
        // Test column 2 vertical pattern
        let verticalPositions: Set<GridPosition> = [
            GridPosition(row: 0, column: 2),
            GridPosition(row: 1, column: 2),
            GridPosition(row: 2, column: 2),
            GridPosition(row: 3, column: 2),
            GridPosition(row: 4, column: 2)
        ]
        
        let patterns = PatternDetector.detectWinningPatterns(selectedPositions: verticalPositions)
        
        guard patterns.count == 1,
              case .vertical(let column) = patterns.first?.type,
              column == 2 else {
            print("❌ Vertical pattern test failed")
            return false
        }
        
        print("✅ Vertical pattern test passed")
        return true
    }
    
    static func testDiagonalPatterns() -> Bool {
        print("Testing diagonal pattern detection...")
        
        // Test main diagonal
        let mainDiagonalPositions: Set<GridPosition> = [
            GridPosition(row: 0, column: 0),
            GridPosition(row: 1, column: 1),
            GridPosition(row: 2, column: 2),
            GridPosition(row: 3, column: 3),
            GridPosition(row: 4, column: 4)
        ]
        
        let mainDiagonalPatterns = PatternDetector.detectWinningPatterns(selectedPositions: mainDiagonalPositions)
        
        guard mainDiagonalPatterns.count == 1,
              mainDiagonalPatterns.first?.type == .diagonalMain else {
            print("❌ Main diagonal pattern test failed")
            return false
        }
        
        // Test anti diagonal
        let antiDiagonalPositions: Set<GridPosition> = [
            GridPosition(row: 0, column: 4),
            GridPosition(row: 1, column: 3),
            GridPosition(row: 2, column: 2),
            GridPosition(row: 3, column: 1),
            GridPosition(row: 4, column: 0)
        ]
        
        let antiDiagonalPatterns = PatternDetector.detectWinningPatterns(selectedPositions: antiDiagonalPositions)
        
        guard antiDiagonalPatterns.count == 1,
              antiDiagonalPatterns.first?.type == .diagonalAnti else {
            print("❌ Anti diagonal pattern test failed")
            return false
        }
        
        print("✅ Diagonal pattern tests passed")
        return true
    }
    
    static func testMultiplePatterns() -> Bool {
        print("Testing multiple pattern detection...")
        
        // Create positions that form both a horizontal and vertical pattern
        // This creates a cross at position (2,2)
        let crossPositions: Set<GridPosition> = [
            // Horizontal row 2
            GridPosition(row: 2, column: 0),
            GridPosition(row: 2, column: 1),
            GridPosition(row: 2, column: 2),
            GridPosition(row: 2, column: 3),
            GridPosition(row: 2, column: 4),
            // Vertical column 2 (row 2 column 2 already included)
            GridPosition(row: 0, column: 2),
            GridPosition(row: 1, column: 2),
            GridPosition(row: 3, column: 2),
            GridPosition(row: 4, column: 2)
        ]
        
        let patterns = PatternDetector.detectWinningPatterns(selectedPositions: crossPositions)
        
        guard patterns.count == 2,
              patterns.contains(where: { 
                  if case .horizontal(let row) = $0.type { return row == 2 }
                  return false
              }),
              patterns.contains(where: { 
                  if case .vertical(let column) = $0.type { return column == 2 }
                  return false
              }) else {
            print("❌ Multiple pattern test failed")
            return false
        }
        
        print("✅ Multiple pattern test passed")
        return true
    }
    
    static func testNoPatterns() -> Bool {
        print("Testing no pattern detection...")
        
        // Create scattered positions that don't form any pattern
        let scatteredPositions: Set<GridPosition> = [
            GridPosition(row: 0, column: 0),
            GridPosition(row: 1, column: 2),
            GridPosition(row: 2, column: 4),
            GridPosition(row: 3, column: 1),
            GridPosition(row: 4, column: 3)
        ]
        
        let patterns = PatternDetector.detectWinningPatterns(selectedPositions: scatteredPositions)
        
        guard patterns.isEmpty else {
            print("❌ No pattern test failed - found unexpected patterns")
            return false
        }
        
        print("✅ No pattern test passed")
        return true
    }
    
    static func testEdgeCases() -> Bool {
        print("Testing edge cases...")
        
        // Test empty set
        let emptyPatterns = PatternDetector.detectWinningPatterns(selectedPositions: Set<GridPosition>())
        guard emptyPatterns.isEmpty else {
            print("❌ Empty set test failed")
            return false
        }
        
        // Test single position
        let singlePosition: Set<GridPosition> = [GridPosition(row: 2, column: 2)]
        let singlePatterns = PatternDetector.detectWinningPatterns(selectedPositions: singlePosition)
        guard singlePatterns.isEmpty else {
            print("❌ Single position test failed")
            return false
        }
        
        // Test utility functions
        let horizontalPositions: Set<GridPosition> = [
            GridPosition(row: 0, column: 0),
            GridPosition(row: 0, column: 1),
            GridPosition(row: 0, column: 2),
            GridPosition(row: 0, column: 3),
            GridPosition(row: 0, column: 4)
        ]
        
        let hasHorizontal = PatternDetector.hasPattern(type: .horizontal(row: 0), selectedPositions: horizontalPositions)
        let hasVertical = PatternDetector.hasPattern(type: .vertical(column: 0), selectedPositions: horizontalPositions)
        
        guard hasHorizontal && !hasVertical else {
            print("❌ Utility function test failed")
            return false
        }
        
        print("✅ Edge case tests passed")
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