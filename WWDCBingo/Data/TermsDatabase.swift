import Foundation

struct TermsDatabase {
    // All available terms for NSLondon DubDub 25 bingo
    static let allTerms: [String] = [
        "One more thing",
        "You're going to love it", 
        "Camera zooming around Apple Park",
        "Someone on a roof",
        "Emotional Steve mention",
        "Xcode for iPad",
        "AI chat in Xcode",
        "iOS 26",
        "Joke about Craig",
        "GOOD MORNEENG",
        "Ford mentioned",
        "Most immersive ever",
        "Update is available RIGHT NOW",
        "Hair Force One",
        "New Icons",
        "A Sherlocking",
        "Our biggest update ever!",
        "AAA Game",
        "Old Game out on macOS",
        "Unified Experience",
        "Only Apple can do this",
        "Android Trash Talk",
        "10x",
        "Announcement for late 25",
        "A video of apps saving lives"
    ]
    
    // Generate a randomized 5x5 bingo grid with "GOOD MORNEENG" always in center
    static func generateRandomGrid() -> [BingoTile] {
        // Ensure we have exactly 25 unique terms
        guard allTerms.count == 25 else {
            fatalError("TermsDatabase must contain exactly 25 terms for a 5x5 grid")
        }
        
        // Special term for center position
        let centerTerm = "GOOD MORNEENG"
        let centerIndex = 12 // Center position (2,2) in 5x5 grid
        
        // Get all other terms (excluding the center term)
        let otherTerms = allTerms.filter { $0 != centerTerm }
        
        // Shuffle the remaining 24 terms
        let shuffledOtherTerms = otherTerms.shuffled()
        
        // Create array to hold all 25 tiles
        var tiles: [BingoTile] = []
        var otherTermIndex = 0
        
        // Create BingoTile objects with positions
        for index in 0..<25 {
            if index == centerIndex {
                // Place "GOOD MORNEENG" at center position
                tiles.append(BingoTile(term: centerTerm, position: GridPosition(index: index)))
            } else {
                // Place shuffled terms at all other positions
                tiles.append(BingoTile(term: shuffledOtherTerms[otherTermIndex], position: GridPosition(index: index)))
                otherTermIndex += 1
            }
        }
        
        return tiles
    }
    
    // Validate that we have the correct number of unique terms
    static func validateTerms() -> Bool {
        let uniqueTerms = Set(allTerms)
        return allTerms.count == 25 && uniqueTerms.count == 25
    }
    
    // Get a specific term by index (for testing)
    static func term(at index: Int) -> String? {
        guard index >= 0 && index < allTerms.count else { return nil }
        return allTerms[index]
    }
    
    // Get total number of available terms
    static var termCount: Int {
        return allTerms.count
    }
    
    // Test function to verify center tile is always "GOOD MORNEENG"
    static func testCenterTileLogic() -> Bool {
        // Generate multiple grids and verify center is always "GOOD MORNEENG"
        for _ in 0..<10 {
            let grid = generateRandomGrid()
            let centerTile = grid[12] // Center position (2,2) has index 12
            if centerTile.term != "GOOD MORNEENG" {
                return false
            }
        }
        return true
    }
} 