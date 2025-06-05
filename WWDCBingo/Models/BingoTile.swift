import Foundation

struct BingoTile: Identifiable, Hashable, Codable {
    let id = UUID()
    let term: String
    let position: GridPosition
    var isSelected: Bool = false
    
    init(term: String, position: GridPosition) {
        self.term = term
        self.position = position
    }
    
    // Mutating function to toggle selection state
    mutating func toggle() {
        isSelected.toggle()
    }
}

// MARK: - Convenience Extensions
extension BingoTile {
    // For testing and preview purposes
    static let sample = BingoTile(
        term: "One more thing",
        position: GridPosition(row: 0, column: 0)
    )
    
    static func sampleGrid() -> [BingoTile] {
        let sampleTerms = [
            "One more thing", "You're going to love it", "Camera zooming",
            "Someone on a roof", "Steve mention", "Xcode for iPad",
            "AI chat", "iOS 26", "Craig joke", "GOOD MORNEENG",
            "Ford mentioned", "Most immersive", "Update RIGHT NOW",
            "Hair Force One", "New Icons", "A Sherlocking",
            "Biggest update", "AAA Game", "Old Game macOS",
            "Unified Experience", "Only Apple", "Android Trash",
            "10x", "Late 25", "Apps saving lives"
        ]
        
        return sampleTerms.enumerated().map { index, term in
            BingoTile(term: term, position: GridPosition(index: index))
        }
    }
} 