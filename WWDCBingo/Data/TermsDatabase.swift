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
    
    // Generate a randomized 5x5 bingo grid
    static func generateRandomGrid() -> [BingoTile] {
        // Ensure we have exactly 25 unique terms
        guard allTerms.count == 25 else {
            fatalError("TermsDatabase must contain exactly 25 terms for a 5x5 grid")
        }
        
        // Shuffle the terms to create random arrangement
        let shuffledTerms = allTerms.shuffled()
        
        // Create BingoTile objects with positions
        return shuffledTerms.enumerated().map { index, term in
            BingoTile(term: term, position: GridPosition(index: index))
        }
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
} 