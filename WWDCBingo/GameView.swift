import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    
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
                            ForEach(Array(viewModel.tiles.enumerated()), id: \.element.id) { index, tile in
                                TileView(
                                    text: tile.term,
                                    isSelected: tile.isSelected
                                ) {
                                    viewModel.toggleTile(at: index)
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
                Text(viewModel.gameStatusText)
                    .font(.caption2)
                    .foregroundColor(viewModel.isGameWon ? .green : .secondary)
                    .fontWeight(viewModel.isGameWon ? .bold : .regular)
                
                if !viewModel.isGameWon {
                    Text("Find a line, column, or diagonal!")
                        .font(.caption2)
                        .foregroundColor(.secondary.opacity(0.7))
                }
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal, 8) // Minimal outer padding
        .navigationTitle("Bingo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if viewModel.selectedCount > 0 {
                    Button("Reset") {
                        viewModel.resetCurrentGame()
                    }
                    .font(.caption)
                    .foregroundColor(.orange)
                }
                
                Button("New Game") {
                    viewModel.startNewGame()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
        }
    }
}

#Preview("Default Game") {
    NavigationView {
        GameView()
    }
}

#Preview("Game with Selections") {
    let viewModel = GameViewModel.previewWithSelections
    return NavigationView {
        GameView()
    }
    .environmentObject(viewModel)
} 
