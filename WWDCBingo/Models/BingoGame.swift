import Foundation

struct BingoGame: Codable {
    let id = UUID()
    let createdAt = Date()
    var tiles: [BingoTile]
    var isGameWon: Bool = false
    var winningPatterns: [WinningPattern] = []
    
    init(tiles: [BingoTile] = []) {
        self.tiles = tiles
    }
    
    // MARK: - Game State Queries
    
    var selectedTilesCount: Int {
        tiles.filter { $0.isSelected }.count
    }
    
    var selectedPositions: Set<GridPosition> {
        Set(tiles.filter { $0.isSelected }.map { $0.position })
    }
    
    var isGridComplete: Bool {
        selectedTilesCount == 25
    }
    
    // MARK: - Tile Management
    
    func tile(at position: GridPosition) -> BingoTile? {
        tiles.first { $0.position == position }
    }
    
    func tile(at index: Int) -> BingoTile? {
        guard index >= 0 && index < tiles.count else { return nil }
        return tiles[index]
    }
    
    mutating func toggleTile(at position: GridPosition) {
        if let index = tiles.firstIndex(where: { $0.position == position }) {
            tiles[index].isSelected.toggle()
            updateWinningState()
        }
    }
    
    mutating func toggleTile(at index: Int) {
        guard index >= 0 && index < tiles.count else { return }
        tiles[index].isSelected.toggle()
        updateWinningState()
    }
    
    // MARK: - Game Control
    
    mutating func resetGame() {
        for index in tiles.indices {
            tiles[index].isSelected = false
        }
        isGameWon = false
        winningPatterns.removeAll()
    }
    
    mutating func setWinningState(patterns: [WinningPattern]) {
        isGameWon = !patterns.isEmpty
        winningPatterns = patterns
    }
    
    // MARK: - Private Methods
    
    private mutating func updateWinningState() {
        let detectedPatterns = PatternDetector.detectWinningPatterns(
            selectedPositions: selectedPositions
        )
        setWinningState(patterns: detectedPatterns)
    }
}

// MARK: - WinningPattern
struct WinningPattern: Codable, Identifiable {
    let id = UUID()
    let type: PatternType
    let positions: [GridPosition]
    
    enum PatternType: Codable, Equatable {
        case horizontal(row: Int)
        case vertical(column: Int)
        case diagonalMain
        case diagonalAnti
        
        var displayName: String {
            switch self {
            case .horizontal(let row):
                return "row \(row + 1)"
            case .vertical(let column):
                return "column \(column + 1)"
            case .diagonalMain:
                return "diagonal \\"
            case .diagonalAnti:
                return "diagonal /"
            }
        }
    }
}

// MARK: - Convenience Extensions
extension BingoGame {
    static func newGame() -> BingoGame {
        let tiles = TermsDatabase.generateRandomGrid()
        return BingoGame(tiles: tiles)
    }
    
    static let sample = BingoGame(tiles: BingoTile.sampleGrid())
} 
