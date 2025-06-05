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
        
        // Check for winning patterns (placeholder for Task 6)
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
        // Placeholder implementation - will be properly implemented in Task 6
        // For now, just clear any existing winning state since we don't have pattern detection yet
        if game.isGameWon {
            game.setWinningState(patterns: [])
        }
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
} 