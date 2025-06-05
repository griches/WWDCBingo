import Foundation
import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
    @Published private(set) var game: BingoGame
    
    // MARK: - Initialization
    
    init(game: BingoGame = BingoGame.newGame()) {
        self.game = game
    }
    
    // MARK: - Public Interface
    
    var tiles: [BingoTile] {
        game.tiles
    }
    
    var selectedCount: Int {
        game.selectedTilesCount
    }
    
    var isGameWon: Bool {
        game.isGameWon
    }
    
    var winningPatterns: [WinningPattern] {
        game.winningPatterns
    }
    
    var gameStatusText: String {
        if game.isGameWon {
            let patternCount = game.winningPatterns.count
            return patternCount == 1 ? "BINGO! 🎉" : "MULTIPLE BINGOS! 🎉"
        } else {
            return "Selected: \(selectedCount)/25"
        }
    }
    
    // MARK: - Game Actions
    
    func toggleTile(at index: Int) {
        guard index >= 0 && index < game.tiles.count else { return }
        
        // Toggle the tile
        game.toggleTile(at: index)
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Check for winning patterns in real-time
        checkForWinningPatterns()
    }
    
    func startNewGame() {
        game = BingoGame.newGame()
    }
    
    func resetCurrentGame() {
        game.resetGame()
    }
    
    // MARK: - Private Methods
    
    private func checkForWinningPatterns() {
        // Use PatternDetector to find all winning patterns
        let detectedPatterns = PatternDetector.detectWinningPatterns(
            selectedPositions: game.selectedPositions
        )
        
        // Update game state with detected patterns
        game.setWinningState(patterns: detectedPatterns)
        
        // Add special haptic feedback for winning
        if !detectedPatterns.isEmpty && detectedPatterns.count != game.winningPatterns.count {
            // Different haptic feedback for winning
            let successFeedback = UINotificationFeedbackGenerator()
            successFeedback.notificationOccurred(.success)
        }
    }
    
    // MARK: - Pattern Query Methods
    
    /// Returns all winning positions (tiles that are part of any winning pattern)
    var winningPositions: Set<GridPosition> {
        Set(game.winningPatterns.flatMap { $0.positions })
    }
    
    /// Checks if a specific position is part of a winning pattern
    func isWinningPosition(_ position: GridPosition) -> Bool {
        return winningPositions.contains(position)
    }
    
    /// Checks if a tile at a specific index is part of a winning pattern
    func isWinningTile(at index: Int) -> Bool {
        guard let tile = game.tile(at: index) else { return false }
        return isWinningPosition(tile.position)
    }
    
    /// Returns a description of all current winning patterns (for debugging)
    var winningPatternsDescription: String {
        return PatternDetector.patternDescription(selectedPositions: game.selectedPositions)
    }
    
    // MARK: - Utility Methods
    
    func tile(at index: Int) -> BingoTile? {
        game.tile(at: index)
    }
    
    func tile(at position: GridPosition) -> BingoTile? {
        game.tile(at: position)
    }
}

// MARK: - Preview Support
extension GameViewModel {
    static let preview = GameViewModel(game: BingoGame.sample)
    
    static let previewWithSelections: GameViewModel = {
        var sampleGame = BingoGame.sample
        // Select a few tiles for preview
        sampleGame.toggleTile(at: 0)
        sampleGame.toggleTile(at: 1)
        sampleGame.toggleTile(at: 6)
        return GameViewModel(game: sampleGame)
    }()
    
    /// Preview with a winning horizontal line for testing
    static let previewWithWin: GameViewModel = {
        var sampleGame = BingoGame.sample
        // Select entire top row for horizontal bingo
        for column in 0..<5 {
            let position = GridPosition(row: 0, column: column)
            sampleGame.toggleTile(at: position)
        }
        
        let viewModel = GameViewModel(game: sampleGame)
        return viewModel
    }()
} 