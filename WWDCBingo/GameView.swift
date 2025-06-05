import SwiftUI

struct GameView: View {
    // Placeholder data for bingo tiles (will be replaced with proper data models in Task 4)
    @State private var tileData: [(text: String, isSelected: Bool)] = [
        ("One more thing", false),
        ("You're going to love it", false),
        ("Camera zooming around Apple Park", false),
        ("Someone on a roof", false),
        ("Emotional Steve mention", false),
        ("Xcode for iPad", false),
        ("AI chat in Xcode", false),
        ("iOS 26", false),
        ("Joke about Craig", false),
        ("GOOD MORNEENG", false),
        ("Ford mentioned", false),
        ("Most immersive ever", false),
        ("Update is available RIGHT NOW", false),
        ("Hair Force One", false),
        ("New Icons", false),
        ("A Sherlocking", false),
        ("Our biggest update ever!", false),
        ("AAA Game", false),
        ("Old Game out on macOS", false),
        ("Unified Experience", false),
        ("Only Apple can do this", false),
        ("Android Trash Talk", false),
        ("10x", false),
        ("Announcement for late 25", false),
        ("A video of apps saving lives", false)
    ]
    
    // Grid layout configuration - minimal spacing for maximum tile size
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 5)
    
    var body: some View {
        VStack(spacing: 8) {
            // Compact Header
            VStack(spacing: 2) {
                Text("WWDC 2025 Bingo")
                    .font(.title3) // Smaller title font
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Tap squares as moments happen!")
                    .font(.caption) // Smaller subtitle
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
            
            // Maximized Bingo Grid
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                
                // Use almost all available width with minimal padding
                let totalPadding: CGFloat = 16 // Minimal horizontal padding
                let totalSpacing: CGFloat = 16 // 4 gaps × 4pt spacing
                let availableWidth = screenWidth - totalPadding
                let tileSize = (availableWidth - totalSpacing) / 5
                
                // Ensure the grid fits in available height, make scrollable if needed
                let gridHeight = tileSize * 5 + totalSpacing
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Center the grid vertically if there's extra space
                        if gridHeight < screenHeight {
                            Spacer()
                                .frame(height: max(0, (screenHeight - gridHeight) / 2))
                        }
                        
                        LazyVGrid(columns: columns, spacing: 4) {
                            ForEach(0..<25, id: \.self) { index in
                                TileView(
                                    text: tileData[index].text,
                                    isSelected: tileData[index].isSelected
                                ) {
                                    toggleTile(at: index)
                                }
                                .frame(width: tileSize, height: tileSize)
                            }
                        }
                        
                        // Center the grid vertically if there's extra space
                        if gridHeight < screenHeight {
                            Spacer()
                                .frame(height: max(0, (screenHeight - gridHeight) / 2))
                        }
                    }
                }
                .padding(.horizontal, 8) // Minimal horizontal padding
            }
            
            // Compact Game Status
            HStack(spacing: 16) {
                Text("Selected: \(selectedCount)/25")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text("Find a line, column, or diagonal!")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.7))
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal, 8) // Minimal outer padding
        .navigationTitle("Bingo")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Private Methods
    
    private func toggleTile(at index: Int) {
        guard index < tileData.count else { return }
        tileData[index].isSelected.toggle()
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    private var selectedCount: Int {
        tileData.filter { $0.isSelected }.count
    }
}

#Preview {
    NavigationView {
        GameView()
    }
} 
