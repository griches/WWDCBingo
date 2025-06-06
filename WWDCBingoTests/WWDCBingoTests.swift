//
//  WWDCBingoTests.swift
//  WWDCBingoTests
//
//  Created by Riches, Gary (G.) on 05/06/2025.
//

import Testing
import Foundation
@testable import WWDCBingo

struct WWDCBingoTests {
    
    // MARK: - Terms Database Tests
    
    @Test func testTermsDatabaseHasCorrectCount() async throws {
        #expect(TermsDatabase.allTerms.count == 25)
    }
    
    @Test func testTermsDatabaseHasUniqueTerms() async throws {
        let terms = TermsDatabase.allTerms
        let uniqueTerms = Set(terms)
        #expect(uniqueTerms.count == terms.count)
    }
    
    @Test func testTermsDatabaseHasNoEmptyTerms() async throws {
        let terms = TermsDatabase.allTerms
        for term in terms {
            #expect(!term.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
    
    @Test func testRandomGridGeneration() async throws {
        let grid1 = TermsDatabase.generateRandomGrid()
        let grid2 = TermsDatabase.generateRandomGrid()
        
        // Both grids should have 25 tiles
        #expect(grid1.count == 25)
        #expect(grid2.count == 25)
        
        // All positions should be unique in each grid
        let positions1 = Set(grid1.map { $0.position })
        let positions2 = Set(grid2.map { $0.position })
        #expect(positions1.count == 25)
        #expect(positions2.count == 25)
        
        // All terms should be unique in each grid
        let terms1 = Set(grid1.map { $0.term })
        let terms2 = Set(grid2.map { $0.term })
        #expect(terms1.count == 25)
        #expect(terms2.count == 25)
        
        // Grids should be different (randomized)
        let grid1Terms = grid1.sorted { $0.position.row < $1.position.row || ($0.position.row == $1.position.row && $0.position.column < $1.position.column) }.map { $0.term }
        let grid2Terms = grid2.sorted { $0.position.row < $1.position.row || ($0.position.row == $1.position.row && $0.position.column < $1.position.column) }.map { $0.term }
        #expect(grid1Terms != grid2Terms)
    }
    
    // MARK: - GridPosition Tests
    
    @Test func testGridPositionEquality() async throws {
        let pos1 = GridPosition(row: 1, column: 2)
        let pos2 = GridPosition(row: 1, column: 2)
        let pos3 = GridPosition(row: 2, column: 1)
        
        #expect(pos1 == pos2)
        #expect(pos1 != pos3)
    }
    
    @Test func testGridPositionHashable() async throws {
        let pos1 = GridPosition(row: 1, column: 2)
        let pos2 = GridPosition(row: 1, column: 2)
        
        let set: Set<GridPosition> = [pos1, pos2]
        #expect(set.count == 1)
    }
    
    // MARK: - BingoTile Tests
    
    @Test func testBingoTileCreation() async throws {
        let position = GridPosition(row: 1, column: 2)
        let tile = BingoTile(term: "Test Term", position: position)
        
        #expect(tile.term == "Test Term")
        #expect(tile.position == position)
        #expect(tile.isSelected == false)
    }
    
    @Test func testBingoTileSelection() async throws {
        let position = GridPosition(row: 1, column: 2)
        var tile = BingoTile(term: "Test Term", position: position)
        
        #expect(tile.isSelected == false)
        
        tile.isSelected = true
        #expect(tile.isSelected == true)
    }
    
    // MARK: - PatternDetector Tests
    
    @Test func testHorizontalPatternDetection() async throws {
        // Test all 5 horizontal patterns
        for row in 0..<5 {
            let horizontalPositions: Set<GridPosition> = (0..<5).map { col in
                GridPosition(row: row, column: col)
            }.reduce(into: Set<GridPosition>()) { set, position in
                set.insert(position)
            }
            
            let patterns = PatternDetector.detectWinningPatterns(selectedPositions: horizontalPositions)
            
            #expect(patterns.count == 1)
            if let pattern = patterns.first {
                if case .horizontal(let detectedRow) = pattern.type {
                    #expect(detectedRow == row)
                } else {
                    Issue.record("Expected horizontal pattern, got \(pattern.type)")
                }
            }
        }
    }
    
    @Test func testVerticalPatternDetection() async throws {
        // Test all 5 vertical patterns
        for column in 0..<5 {
            let verticalPositions: Set<GridPosition> = (0..<5).map { row in
                GridPosition(row: row, column: column)
            }.reduce(into: Set<GridPosition>()) { set, position in
                set.insert(position)
            }
            
            let patterns = PatternDetector.detectWinningPatterns(selectedPositions: verticalPositions)
            
            #expect(patterns.count == 1)
            if let pattern = patterns.first {
                if case .vertical(let detectedColumn) = pattern.type {
                    #expect(detectedColumn == column)
                } else {
                    Issue.record("Expected vertical pattern, got \(pattern.type)")
                }
            }
        }
    }
    
    @Test func testMainDiagonalPatternDetection() async throws {
        let mainDiagonalPositions: Set<GridPosition> = (0..<5).map { i in
            GridPosition(row: i, column: i)
        }.reduce(into: Set<GridPosition>()) { set, position in
            set.insert(position)
        }
        
        let patterns = PatternDetector.detectWinningPatterns(selectedPositions: mainDiagonalPositions)
        
        #expect(patterns.count == 1)
        if let pattern = patterns.first {
            #expect(pattern.type == .diagonalMain)
        }
    }
    
    @Test func testAntiDiagonalPatternDetection() async throws {
        let antiDiagonalPositions: Set<GridPosition> = (0..<5).map { i in
            GridPosition(row: i, column: 4 - i)
        }.reduce(into: Set<GridPosition>()) { set, position in
            set.insert(position)
        }
        
        let patterns = PatternDetector.detectWinningPatterns(selectedPositions: antiDiagonalPositions)
        
        #expect(patterns.count == 1)
        if let pattern = patterns.first {
            #expect(pattern.type == .diagonalAnti)
        }
    }
    
    @Test func testMultiplePatternDetection() async throws {
        // Create a cross pattern that forms both horizontal and vertical lines
        var crossPositions: Set<GridPosition> = Set()
        
        // Add horizontal line at row 2
        for col in 0..<5 {
            crossPositions.insert(GridPosition(row: 2, column: col))
        }
        
        // Add vertical line at column 2
        for row in 0..<5 {
            crossPositions.insert(GridPosition(row: row, column: 2))
        }
        
        let patterns = PatternDetector.detectWinningPatterns(selectedPositions: crossPositions)
        
        #expect(patterns.count == 2)
        
        let hasHorizontal = patterns.contains { pattern in
            if case .horizontal(let row) = pattern.type {
                return row == 2
            }
            return false
        }
        
        let hasVertical = patterns.contains { pattern in
            if case .vertical(let column) = pattern.type {
                return column == 2
            }
            return false
        }
        
        #expect(hasHorizontal)
        #expect(hasVertical)
    }
    
    @Test func testNoPatternDetection() async throws {
        // Create scattered positions that don't form any pattern
        let scatteredPositions: Set<GridPosition> = [
            GridPosition(row: 0, column: 0),
            GridPosition(row: 1, column: 2),
            GridPosition(row: 2, column: 4),
            GridPosition(row: 3, column: 1)
        ]
        
        let patterns = PatternDetector.detectWinningPatterns(selectedPositions: scatteredPositions)
        #expect(patterns.isEmpty)
    }
    
    @Test func testEmptyPositionsNoPattern() async throws {
        let patterns = PatternDetector.detectWinningPatterns(selectedPositions: Set<GridPosition>())
        #expect(patterns.isEmpty)
    }
    
    // MARK: - BingoGame Tests
    
    @Test func testBingoGameInitialization() async throws {
        let game = BingoGame.newGame()
        
        #expect(game.tiles.count == 25)
        #expect(game.selectedTilesCount == 0)
        #expect(game.isGameWon == false)
        #expect(game.winningPatterns.isEmpty)
        
        // Check all tiles are initially unselected
        for tile in game.tiles {
            #expect(tile.isSelected == false)
        }
        
        // Check all positions are unique
        let positions = Set(game.tiles.map { $0.position })
        #expect(positions.count == 25)
        
        // Check all terms are unique
        let terms = Set(game.tiles.map { $0.term })
        #expect(terms.count == 25)
    }
    
    @Test func testBingoGameTileToggling() async throws {
        var game = BingoGame.newGame()
        
        // Toggle first tile
        game.toggleTile(at: 0)
        #expect(game.tiles[0].isSelected == true)
        #expect(game.selectedTilesCount == 1)
        
        // Toggle it back
        game.toggleTile(at: 0)
        #expect(game.tiles[0].isSelected == false)
        #expect(game.selectedTilesCount == 0)
    }
    
    @Test func testBingoGameInvalidTileIndex() async throws {
        var game = BingoGame.newGame()
        
        // Try to toggle invalid indices
        game.toggleTile(at: -1)
        game.toggleTile(at: 25)
        game.toggleTile(at: 100)
        
        // No tiles should be selected
        #expect(game.selectedTilesCount == 0)
    }
    
    @Test func testBingoGameReset() async throws {
        var game = BingoGame.newGame()
        
        // Select some tiles
        game.toggleTile(at: 0)
        game.toggleTile(at: 5)
        game.toggleTile(at: 10)
        
        #expect(game.selectedTilesCount == 3)
        
        // Reset game
        game.resetGame()
        
        #expect(game.selectedTilesCount == 0)
        for tile in game.tiles {
            #expect(tile.isSelected == false)
        }
    }
    
    @Test func testBingoGameWinningCondition() async throws {
        var game = BingoGame.newGame()
        
        // Select first row to create a winning pattern
        for col in 0..<5 {
            if let index = game.tiles.firstIndex(where: { $0.position == GridPosition(row: 0, column: col) }) {
                game.toggleTile(at: index)
            }
        }
        
        #expect(game.isGameWon == true)
        #expect(game.winningPatterns.count >= 1)
        
        // Check that we have a horizontal pattern
        let hasHorizontalPattern = game.winningPatterns.contains { pattern in
            if case .horizontal(let row) = pattern.type {
                return row == 0
            }
            return false
        }
        #expect(hasHorizontalPattern)
    }
    
    // MARK: - Performance Tests
    
    @Test func testPatternDetectionPerformance() async throws {
        // Create a large set of positions to test performance
        var allPositions: Set<GridPosition> = Set()
        for row in 0..<5 {
            for col in 0..<5 {
                allPositions.insert(GridPosition(row: row, column: col))
            }
        }
        
        // Measure time for pattern detection
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<1000 {
            _ = PatternDetector.detectWinningPatterns(selectedPositions: allPositions)
        }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        
        // Pattern detection should be fast (less than 1 second for 1000 iterations)
        #expect(timeElapsed < 1.0)
    }
    
    @Test func testGameCreationPerformance() async throws {
        // Test that game creation is fast
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<100 {
            _ = BingoGame.newGame()
        }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        
        // Game creation should be fast (less than 1 second for 100 games)
        #expect(timeElapsed < 1.0)
    }
    
    // MARK: - Edge Case Tests
    
    @Test @MainActor func testPatternTypeDisplayNames() async throws {
        let horizontalType = WinningPattern.PatternType.horizontal(row: 2)
        let verticalType = WinningPattern.PatternType.vertical(column: 3)
        let mainDiagonalType = WinningPattern.PatternType.diagonalMain
        let antiDiagonalType = WinningPattern.PatternType.diagonalAnti
        
        #expect(!horizontalType.displayName.isEmpty)
        #expect(!verticalType.displayName.isEmpty)
        #expect(!mainDiagonalType.displayName.isEmpty)
        #expect(!antiDiagonalType.displayName.isEmpty)
        
        #expect(horizontalType.displayName.contains("row"))
        #expect(verticalType.displayName.contains("column"))
        #expect(mainDiagonalType.displayName.contains("diagonal"))
        #expect(antiDiagonalType.displayName.contains("diagonal"))
    }
    
    @Test func testGameStateConsistency() async throws {
        var game = BingoGame.newGame()
        
        // Select tiles in a way that creates multiple patterns
        let positions = [
            GridPosition(row: 2, column: 0),
            GridPosition(row: 2, column: 1),
            GridPosition(row: 2, column: 2),
            GridPosition(row: 2, column: 3),
            GridPosition(row: 2, column: 4),
            GridPosition(row: 0, column: 2),
            GridPosition(row: 1, column: 2),
            GridPosition(row: 3, column: 2),
            GridPosition(row: 4, column: 2)
        ]
        
        for position in positions {
            if let index = game.tiles.firstIndex(where: { $0.position == position }) {
                game.toggleTile(at: index)
            }
        }
        
        #expect(game.isGameWon == true)
        #expect(game.winningPatterns.count == 2)
        #expect(game.selectedTilesCount == 9)
        
        // The selected positions should match what we expect
        let selectedPositions = Set(game.tiles.filter { $0.isSelected }.map { $0.position })
        let expectedPositions = Set(positions)
        #expect(selectedPositions == expectedPositions)
    }
}
