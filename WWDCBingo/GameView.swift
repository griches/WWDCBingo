import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @StateObject private var soundManager = SoundManager.shared
    
    // Accessibility and environment support
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AccessibilityFocusState private var gridFocused: Bool
    
    // Grid layout configuration - minimal spacing for maximum tile size
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 5)
    
    var body: some View {
        ZStack {
            // Main game content
            VStack(spacing: 8) {
                // Compact Header with accessibility support
                VStack(spacing: 2) {
                    Text("NSLondon DubDub 25")
                        .font(scaledTitleFont)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityLabel("NSLondon DubDub 25 Game")
                    
                    Text("Tap squares as moments happen!")
                        .font(scaledSubtitleFont)
                        .foregroundColor(.secondary)
                        .accessibilityLabel("Instructions: Tap squares as moments happen during the event")
                }
                .padding(.top, 8)
                
                // Maximized Bingo Grid with enhanced accessibility
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
                                        isSelected: tile.isSelected,
                                        isWinning: viewModel.isWinningTile(at: index)
                                    ) {
                                        viewModel.toggleTile(at: index)
                                    }
                                    .frame(width: tileSize, height: tileSize)
                                    .accessibilityFocused($gridFocused, equals: index == 0)
                                }
                            }
                            .accessibilityElement(children: .contain)
                            .accessibilityLabel("Bingo grid")
                            .accessibilityHint("5 by 5 grid of bingo terms. Double tap any term to select it.")
                            
                            // Center the grid vertically if there's extra space
                            if gridHeight < screenHeight {
                                Spacer()
                                    .frame(height: max(0, (screenHeight - gridHeight) / 2))
                            }
                        }
                    }
                    .padding(.horizontal, 8) // Minimal horizontal padding
                }
                
                // Compact Game Status with Fixed Height and accessibility
                VStack(spacing: 4) {
                    HStack(spacing: 16) {
                        Text(viewModel.gameStatusText)
                            .font(scaledStatusFont)
                            .foregroundColor(viewModel.isGameWon ? .green : .secondary)
                            .fontWeight(viewModel.isGameWon ? .bold : .regular)
                            .accessibilityLabel("Game status: \(viewModel.gameStatusText)")
                        
                        if !viewModel.isGameWon {
                            Text("Find a line, column, or diagonal!")
                                .font(scaledStatusFont)
                                .foregroundColor(.secondary.opacity(0.7))
                                .accessibilityLabel("Goal: Find a line, column, or diagonal")
                        }
                    }
                    
                    // Fixed height area for winning pattern details to prevent layout shift
                    Text(viewModel.isGameWon && !viewModel.winningPatterns.isEmpty ? winningPatternsText : "")
                        .font(scaledStatusFont)
                        .foregroundColor(.green)
                        .fontWeight(.medium)
                        .opacity(viewModel.isGameWon && !viewModel.winningPatterns.isEmpty ? 1.0 : 0.0)
                        .accessibilityLabel(viewModel.isGameWon && !viewModel.winningPatterns.isEmpty ? 
                            "Winning patterns: \(winningPatternsText)" : "")
                }
                .frame(height: statusAreaHeight)
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 8) // Minimal outer padding
            
            // Confetti Animation Layer with accessibility consideration
            if viewModel.showConfetti {
                ConfettiView(isActive: viewModel.showConfetti, duration: 3.0)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true) // Hide decorative confetti from VoiceOver
            }
            
            // Victory Overlay with enhanced accessibility
            if viewModel.showVictoryOverlay {
                VictoryOverlayView(
                    winningPatterns: viewModel.winningPatterns,
                    onNewGame: viewModel.newGameFromVictory,
                    onContinue: viewModel.continueGame
                )
                .transition(.asymmetric(
                    insertion: reduceMotion ? .opacity : .scale(scale: 0.3).combined(with: .opacity),
                    removal: reduceMotion ? .opacity : .scale(scale: 1.1).combined(with: .opacity)
                ))
                .animation(
                    reduceMotion ? .none : .bouncy(duration: 0.6), 
                    value: viewModel.showVictoryOverlay
                )
                .accessibilityFocused($gridFocused, equals: false)
            }
        }
        .navigationTitle("Bingo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                // Sound toggle button with accessibility
                Button(action: {
                    soundManager.toggleSound()
                }) {
                    Image(systemName: soundManager.isSoundEnabled ? "speaker.2.fill" : "speaker.slash.fill")
                        .foregroundColor(soundManager.isSoundEnabled ? .blue : .gray)
                }
                .accessibilityLabel(soundManager.isSoundEnabled ? "Sound enabled" : "Sound disabled")
                .accessibilityHint("Double tap to toggle sound effects")
            }
        }
    }
    
    // MARK: - Dynamic Type Support
    
    private var scaledTitleFont: Font {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return .title2
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .title3
        default:
            return .title3
        }
    }
    
    private var scaledSubtitleFont: Font {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return .body
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .callout
        default:
            return .caption
        }
    }
    
    private var scaledStatusFont: Font {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return .callout
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .caption
        default:
            return .caption2
        }
    }
    
    private var scaledToolbarFont: Font {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge, 
             .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .body
        default:
            return .caption
        }
    }
    
    private var statusAreaHeight: CGFloat {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return 60
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return 80
        default:
            return 44
        }
    }
    
    // MARK: - Computed Properties
    
    private var winningPatternsText: String {
        let patterns = viewModel.winningPatterns
        if patterns.count == 1 {
            return patterns.first?.type.displayName ?? ""
        } else {
            let types = patterns.map { $0.type.displayName }
            return types.joined(separator: " & ")
        }
    }
}

#Preview("Default Game") {
    NavigationView {
        GameView()
    }
}

#Preview("Game with Selections") {
    NavigationView {
        GameView()
    }
    .environmentObject(GameViewModel.previewWithSelections)
}

#Preview("Game with Victory") {
    NavigationView {
        GameView()
    }
    .environmentObject(GameViewModel.previewWithVictory)
} 
