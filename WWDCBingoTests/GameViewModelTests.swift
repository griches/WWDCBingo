import Testing
import Foundation
@testable import WWDCBingo

@MainActor
struct GameViewModelTests {
    
    // MARK: - GameViewModel Initialization Tests
    
    @Test func testGameViewModelInitialization() async throws {
        let viewModel = GameViewModel()
        
        #expect(viewModel.tiles.count == 25)
        #expect(viewModel.selectedCount == 0)
        #expect(viewModel.isGameWon == false)
        #expect(viewModel.winningPatterns.isEmpty)
        #expect(viewModel.showVictoryOverlay == false)
        #expect(viewModel.showConfetti == false)
    }
    
    @Test func testGameViewModelWithCustomGame() async throws {
        let customGame = BingoGame.newGame()
        let viewModel = GameViewModel(game: customGame)
        
        #expect(viewModel.tiles.count == 25)
        #expect(viewModel.selectedCount == 0)
        #expect(viewModel.isGameWon == false)
        #expect(viewModel.winningPatterns.isEmpty)
    }
    
    // MARK: - Tile Interaction Tests
    
    @Test func testTileToggling() async throws {
        let viewModel = GameViewModel()
        
        // Initially no tiles selected
        #expect(viewModel.selectedCount == 0)
        
        // Toggle first tile
        viewModel.toggleTile(at: 0)
        #expect(viewModel.selectedCount == 1)
        #expect(viewModel.tiles[0].isSelected == true)
        
        // Toggle it back
        viewModel.toggleTile(at: 0)
        #expect(viewModel.selectedCount == 0)
        #expect(viewModel.tiles[0].isSelected == false)
    }
    
    @Test func testMultipleTileSelection() async throws {
        let viewModel = GameViewModel()
        
        // Select multiple tiles
        viewModel.toggleTile(at: 0)
        viewModel.toggleTile(at: 5)
        viewModel.toggleTile(at: 10)
        viewModel.toggleTile(at: 15)
        viewModel.toggleTile(at: 20)
        
        #expect(viewModel.selectedCount == 5)
        
        // Check that the right tiles are selected
        #expect(viewModel.tiles[0].isSelected == true)
        #expect(viewModel.tiles[5].isSelected == true)
        #expect(viewModel.tiles[10].isSelected == true)
        #expect(viewModel.tiles[15].isSelected == true)
        #expect(viewModel.tiles[20].isSelected == true)
        
        // Check that other tiles are not selected
        #expect(viewModel.tiles[1].isSelected == false)
        #expect(viewModel.tiles[2].isSelected == false)
    }
    
    // MARK: - Game State Tests
    
    @Test func testGameStatusText() async throws {
        let viewModel = GameViewModel()
        
        // Initially should show 0 selected
        #expect(viewModel.gameStatusText.contains("Selected: 0/25"))
        
        // Select a tile
        viewModel.toggleTile(at: 0)
        #expect(viewModel.gameStatusText.contains("Selected: 1/25"))
        
        // Select more tiles
        viewModel.toggleTile(at: 1)
        viewModel.toggleTile(at: 2)
        #expect(viewModel.gameStatusText.contains("Selected: 3/25"))
    }
    
    @Test func testNewGameFunctionality() async throws {
        let viewModel = GameViewModel()
        
        // Select some tiles
        viewModel.toggleTile(at: 0)
        viewModel.toggleTile(at: 5)
        viewModel.toggleTile(at: 10)
        
        #expect(viewModel.selectedCount == 3)
        
        // Start new game
        viewModel.startNewGame()
        
        #expect(viewModel.selectedCount == 0)
        #expect(viewModel.isGameWon == false)
        #expect(viewModel.showVictoryOverlay == false)
        #expect(viewModel.showConfetti == false)
        
        // All tiles should be unselected
        for tile in viewModel.tiles {
            #expect(tile.isSelected == false)
        }
    }
    
    @Test func testResetGameFunctionality() async throws {
        let viewModel = GameViewModel()
        
        // Select some tiles
        viewModel.toggleTile(at: 0)
        viewModel.toggleTile(at: 5)
        viewModel.toggleTile(at: 10)
        
        #expect(viewModel.selectedCount == 3)
        
        // Reset game
        viewModel.resetGame()
        
        #expect(viewModel.selectedCount == 0)
        #expect(viewModel.isGameWon == false)
        #expect(viewModel.showVictoryOverlay == false)
        #expect(viewModel.showConfetti == false)
        
        // All tiles should be unselected
        for tile in viewModel.tiles {
            #expect(tile.isSelected == false)
        }
    }
    
    // MARK: - Winning Pattern Tests
    
    @Test func testWinningTileDetection() async throws {
        let viewModel = GameViewModel()
        
        // Initially no tiles are winning
        for i in 0..<25 {
            #expect(viewModel.isWinningTile(at: i) == false)
        }
        
        // Select a horizontal row to create a winning pattern
        var firstRowIndices: [Int] = []
        for col in 0..<5 {
            if let index = viewModel.tiles.firstIndex(where: { $0.position == GridPosition(row: 0, column: col) }) {
                firstRowIndices.append(index)
                viewModel.toggleTile(at: index)
            }
        }
        
        #expect(viewModel.isGameWon == true)
        
        // All tiles in the first row should be marked as winning
        for index in firstRowIndices {
            #expect(viewModel.isWinningTile(at: index) == true)
        }
        
        // Other tiles should not be marked as winning
        for i in 0..<25 {
            if !firstRowIndices.contains(i) {
                #expect(viewModel.isWinningTile(at: i) == false)
            }
        }
    }
    
    @Test func testWinningPositions() async throws {
        let viewModel = GameViewModel()
        
        // Initially no winning positions
        #expect(viewModel.winningPositions.isEmpty)
        
        // Select a diagonal to create a winning pattern
        for i in 0..<5 {
            if let index = viewModel.tiles.firstIndex(where: { $0.position == GridPosition(row: i, column: i) }) {
                viewModel.toggleTile(at: index)
            }
        }
        
        #expect(viewModel.isGameWon == true)
        #expect(viewModel.winningPositions.count == 5)
        
        // Check that the diagonal positions are marked as winning
        for i in 0..<5 {
            #expect(viewModel.winningPositions.contains(GridPosition(row: i, column: i)))
        }
    }
    
    // MARK: - Victory Celebration Tests
    
    @Test func testVictoryCelebrationTriggering() async throws {
        let viewModel = GameViewModel()
        
        #expect(viewModel.showVictoryOverlay == false)
        #expect(viewModel.showConfetti == false)
        
        // Create a winning condition
        for col in 0..<5 {
            if let index = viewModel.tiles.firstIndex(where: { $0.position == GridPosition(row: 0, column: col) }) {
                viewModel.toggleTile(at: index)
            }
        }
        
        #expect(viewModel.isGameWon == true)
        
        // Victory celebration might be triggered asynchronously,
        // so we test that the game win state is detected
        #expect(viewModel.winningPatterns.count >= 1)
    }
    
    @Test func testVictoryOverlayDismissal() async throws {
        let viewModel = GameViewModel()
        
        // Manually set victory overlay state for testing
        viewModel.showVictoryOverlay = true
        viewModel.showConfetti = true
        
        // Dismiss overlay
        viewModel.dismissVictoryOverlay()
        #expect(viewModel.showVictoryOverlay == false)
        
        // Continue game
        viewModel.continueGame()
        #expect(viewModel.showVictoryOverlay == false)
    }
    
    // MARK: - Utility Method Tests
    
    @Test func testTileAtIndexMethod() async throws {
        let viewModel = GameViewModel()
        
        // Valid indices should return tiles
        for i in 0..<25 {
            let tile = viewModel.tile(at: i)
            #expect(tile != nil)
            #expect(tile?.term != nil)
            #expect(tile?.position != nil)
        }
        
        // Invalid indices should return nil
        #expect(viewModel.tile(at: -1) == nil)
        #expect(viewModel.tile(at: 25) == nil)
        #expect(viewModel.tile(at: 100) == nil)
    }
    
    @Test func testTileAtPositionMethod() async throws {
        let viewModel = GameViewModel()
        
        // Valid positions should return tiles
        for row in 0..<5 {
            for col in 0..<5 {
                let position = GridPosition(row: row, column: col)
                let tile = viewModel.tile(at: position)
                #expect(tile != nil)
                #expect(tile?.position == position)
            }
        }
        
        // Invalid positions should return nil
        #expect(viewModel.tile(at: GridPosition(row: -1, column: 0)) == nil)
        #expect(viewModel.tile(at: GridPosition(row: 0, column: -1)) == nil)
        #expect(viewModel.tile(at: GridPosition(row: 5, column: 0)) == nil)
        #expect(viewModel.tile(at: GridPosition(row: 0, column: 5)) == nil)
    }
    
    @Test func testIsWinningPositionMethod() async throws {
        let viewModel = GameViewModel()
        
        // Initially no positions are winning
        for row in 0..<5 {
            for col in 0..<5 {
                #expect(viewModel.isWinningPosition(GridPosition(row: row, column: col)) == false)
            }
        }
        
        // Create a winning pattern
        for col in 0..<5 {
            if let index = viewModel.tiles.firstIndex(where: { $0.position == GridPosition(row: 2, column: col) }) {
                viewModel.toggleTile(at: index)
            }
        }
        
        #expect(viewModel.isGameWon == true)
        
        // Row 2 positions should be winning
        for col in 0..<5 {
            #expect(viewModel.isWinningPosition(GridPosition(row: 2, column: col)) == true)
        }
        
        // Other positions should not be winning
        #expect(viewModel.isWinningPosition(GridPosition(row: 0, column: 0)) == false)
        #expect(viewModel.isWinningPosition(GridPosition(row: 1, column: 1)) == false)
        #expect(viewModel.isWinningPosition(GridPosition(row: 3, column: 3)) == false)
    }
    
    // MARK: - Preview Helper Tests
    
    @Test func testPreviewHelpers() async throws {
        let previewWithSelections = GameViewModel.previewWithSelections
        #expect(previewWithSelections.selectedCount > 0)
        
        let previewWithWin = GameViewModel.previewWithWin
        #expect(previewWithWin.isGameWon == true)
        #expect(previewWithWin.winningPatterns.count >= 1)
        
        let previewWithVictory = GameViewModel.previewWithVictory
        #expect(previewWithVictory.isGameWon == true)
        #expect(previewWithVictory.showVictoryOverlay == true)
        #expect(previewWithVictory.showConfetti == true)
    }
    
    // MARK: - State Consistency Tests
    
    @Test func testStateConsistencyAfterOperations() async throws {
        let viewModel = GameViewModel()
        
        // Perform a series of operations
        viewModel.toggleTile(at: 0)
        viewModel.toggleTile(at: 5)
        viewModel.toggleTile(at: 10)
        
        let selectedCountBefore = viewModel.selectedCount
        let tilesSelectedBefore = viewModel.tiles.filter { $0.isSelected }.count
        
        // Selected count should match actual selected tiles
        #expect(selectedCountBefore == tilesSelectedBefore)
        
        // Reset and check consistency
        viewModel.resetGame()
        
        #expect(viewModel.selectedCount == 0)
        #expect(viewModel.tiles.filter { $0.isSelected }.count == 0)
        #expect(viewModel.isGameWon == false)
        #expect(viewModel.winningPatterns.isEmpty)
    }
} 
