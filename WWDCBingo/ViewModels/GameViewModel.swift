import Foundation
import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
    @Published private(set) var game: BingoGame
    @Published var showVictoryOverlay: Bool = false
    @Published var showConfetti: Bool = false
    
    private var soundManager = SoundManager.shared
    private var previousPatternCount: Int = 0
    
    // MARK: - Initialization
    
    init(game: BingoGame = BingoGame.newGame()) {
        self.game = game
        self.previousPatternCount = game.winningPatterns.count
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
            return patternCount == 1 ? 
                "🎉 BINGO! You got bingo on \(game.winningPatterns.first?.type.displayName ?? "pattern")!" :
                "🎉 AMAZING! You've got \(patternCount) matches!"
        } else {
            return ""
        }
    }
    
    var winningPositions: Set<GridPosition> {
        Set(game.winningPatterns.flatMap { $0.positions })
    }
    
    // MARK: - Game Actions
    
    func toggleTile(at index: Int) {
        guard index < game.tiles.count else { return }
        
        let tile = game.tiles[index]
        let wasSelected = tile.isSelected
        
        // Provide haptic feedback for tile tap
        soundManager.playTileSelectionFeedback()
        
        // Toggle the tile
        game.toggleTile(at: index)
        
        // Accessibility announcement for tile state change
        let actionText = wasSelected ? "deselected" : "selected"
        let announcement = "\(tile.term) \(actionText)"
        UIAccessibility.post(notification: .announcement, argument: announcement)
        
        // Check for new winning patterns
        checkForNewPatterns()
    }
    
    func startNewGame() {
        game = BingoGame.newGame()
        previousPatternCount = 0
        showVictoryOverlay = false
        showConfetti = false
        
        // Accessibility announcement for new game
        UIAccessibility.post(notification: .announcement, argument: "New game started. All tiles reset.")
    }
    
    func resetGame() {
        game.resetGame()
        previousPatternCount = 0
        showVictoryOverlay = false
        showConfetti = false
        
        // Accessibility announcement for game reset
        UIAccessibility.post(notification: .announcement, argument: "Game reset. All tiles deselected.")
    }
    
    // MARK: - Victory Celebration Actions
    
    func dismissVictoryOverlay() {
        showVictoryOverlay = false
    }
    
    func continueGame() {
        showVictoryOverlay = false
        // Keep confetti going for a bit longer after dismissing overlay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showConfetti = false
        }
    }
    
    func newGameFromVictory() {
        startNewGame()
    }
    
    // MARK: - Helper Methods
    
    func isWinningTile(at index: Int) -> Bool {
        guard index < game.tiles.count else { return false }
        let position = game.tiles[index].position
        
        return game.winningPatterns.contains { pattern in
            pattern.positions.contains(position)
        }
    }
    
    // MARK: - Private Methods
    
    private func checkForNewPatterns() {
        let currentPatternCount = game.winningPatterns.count
        
        // Check if we have new patterns (more than before)
        if currentPatternCount > previousPatternCount {
            // New bingo(s) detected!
            triggerVictoryCelebration()
            previousPatternCount = currentPatternCount
        }
    }
    
    private func triggerVictoryCelebration() {
        // Play victory sound and enhanced haptic feedback
        soundManager.playVictorySound()
        soundManager.playVictoryHapticFeedback()
        
        // Create accessibility announcement for victory
        let patternCount = game.winningPatterns.count
        let victoryAnnouncement = if patternCount == 1 {
            "Congratulations! You achieved BINGO with a \(game.winningPatterns.first?.type.displayName ?? "winning pattern")!"
        } else {
            "Amazing! You achieved BINGO with \(patternCount) different patterns!"
        }
        
        // Post victory announcement immediately
        UIAccessibility.post(notification: .announcement, argument: victoryAnnouncement)
        
        // Start confetti animation
        showConfetti = true
        
        // Show victory overlay after a brief delay to let confetti start
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showVictoryOverlay = true
        }
        
        // Auto-stop confetti after 3 seconds if user doesn't interact
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.showVictoryOverlay {
                // Still showing overlay, keep confetti going
            } else {
                self.showConfetti = false
            }
        }
    }
    
    /// Checks if a specific position is part of a winning pattern
    func isWinningPosition(_ position: GridPosition) -> Bool {
        return winningPositions.contains(position)
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

// MARK: - Preview Helpers
extension GameViewModel {
    static var previewWithSelections: GameViewModel {
        let viewModel = GameViewModel()
        // Select some tiles for preview
        viewModel.toggleTile(at: 0)
        viewModel.toggleTile(at: 1)
        viewModel.toggleTile(at: 2)
        return viewModel
    }
    
    static var previewWithWin: GameViewModel {
        let viewModel = GameViewModel()
        // Select a winning row for preview
        for i in 0..<5 {
            viewModel.toggleTile(at: i)
        }
        return viewModel
    }
    
    static var previewWithVictory: GameViewModel {
        let viewModel = GameViewModel()
        // Create a victory state for preview
        for i in 0..<5 {
            viewModel.game.toggleTile(at: i)
        }
        viewModel.showVictoryOverlay = true
        viewModel.showConfetti = true
        return viewModel
    }
} 
