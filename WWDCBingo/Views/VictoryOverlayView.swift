import SwiftUI

struct VictoryOverlayView: View {
    let winningPatterns: [WinningPattern]
    let onNewGame: () -> Void
    let onContinue: () -> Void
    
    // Accessibility and environment support
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme
    @AccessibilityFocusState private var overlayFocused: Bool
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            // Semi-transparent background with accessibility
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    onContinue()
                }
                .accessibilityHidden(true) // Hide background from VoiceOver
            
            // Victory card with enhanced accessibility
            VStack(spacing: dynamicSpacing) {
                // Victory emoji and text with accessibility
                VStack(spacing: 12) {
                    Text("🎉")
                        .font(.system(size: emojiSize))
                        .scaleEffect(reduceMotion ? 1.0 : scale)
                        .accessibilityLabel("Celebration emoji")
                        .accessibilityHidden(false)
                    
                    Text("BINGO!")
                        .font(scaledTitleFont)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .accessibilityLabel("Bingo! You won!")
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityFocused($overlayFocused)
                    
                    Text(victoryMessage)
                        .font(scaledSubtitleFont)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(sizeCategory.isAccessibilityCategory ? nil : 3)
                        .accessibilityLabel(accessibleVictoryMessage)
                }
                
                // Action button with enhanced accessibility
                Button(action: onContinue) {
                    HStack {
                        Image(systemName: "play.fill")
                            .font(scaledButtonIconFont)
                        Text("Keep Playing")
                            .font(scaledButtonFont)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, buttonPadding)
                    .background(buttonBackground)
                    .cornerRadius(12)
                }
                .accessibilityLabel("Keep playing")
                .accessibilityHint("Double tap to continue playing and look for more bingo patterns")
                .accessibilityAction(.default) {
                    onContinue()
                }
            }
            .padding(cardPadding)
            .background(cardBackground)
            .padding(.horizontal, horizontalPadding)
            .scaleEffect(reduceMotion ? 1.0 : scale)
            .opacity(opacity)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Victory celebration")
        }
        .onAppear {
            // Auto-focus on victory message for VoiceOver users
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                overlayFocused = true
            }
            
            // Animate appearance with reduced motion support
            if reduceMotion {
                scale = 1.0
                opacity = 1.0
            } else {
                withAnimation(.bouncy(duration: 0.6)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
        }
    }
    
    // MARK: - Dynamic Type Support
    
    private var scaledTitleFont: Font {
        switch sizeCategory {
        case .accessibilityMedium:
            return .title
        case .accessibilityLarge:
            return .title2
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .title3
        default:
            return .largeTitle
        }
    }
    
    private var scaledSubtitleFont: Font {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return .headline
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .body
        default:
            return .title3
        }
    }
    
    private var scaledButtonFont: Font {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return .body
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .callout
        default:
            return .headline
        }
    }
    
    private var scaledButtonIconFont: Font {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return .body
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .callout
        default:
            return .headline
        }
    }
    
    // MARK: - Dynamic Layout Support
    
    private var dynamicSpacing: CGFloat {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return 16
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return 12
        default:
            return 20
        }
    }
    
    private var emojiSize: CGFloat {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return 48
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return 36
        default:
            return 60
        }
    }
    
    private var cardPadding: CGFloat {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return 20
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return 16
        default:
            return 24
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return 30
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return 20
        default:
            return 40
        }
    }
    
    private var buttonPadding: CGFloat {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return 16
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return 20
        default:
            return 12
        }
    }
    
    // MARK: - Style Support
    
    private var buttonBackground: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [.blue, .cyan]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.regularMaterial)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Accessibility Messages
    
    private var victoryMessage: String {
        if winningPatterns.count == 1 {
            return "You got a \(winningPatterns.first?.type.displayName ?? "bingo")!"
        } else {
            let types = winningPatterns.map { $0.type.displayName }
            return "Amazing! You got \(types.joined(separator: " & "))!"
        }
    }
    
    private var accessibleVictoryMessage: String {
        if winningPatterns.count == 1 {
            let patternName = winningPatterns.first?.type.displayName ?? "bingo pattern"
            return "Congratulations! You completed a \(patternName) pattern."
        } else {
            let types = winningPatterns.map { $0.type.displayName }
            let patternsText = types.joined(separator: " and ")
            return "Amazing! You completed multiple patterns: \(patternsText)."
        }
    }
}

#Preview("Single Win") {
    ZStack {
        Color.gray.ignoresSafeArea()
        
        VictoryOverlayView(
            winningPatterns: [
                WinningPattern(
                    type: .horizontal(row: 0),
                    positions: [
                        GridPosition(row: 0, column: 0),
                        GridPosition(row: 0, column: 1),
                        GridPosition(row: 0, column: 2),
                        GridPosition(row: 0, column: 3),
                        GridPosition(row: 0, column: 4)
                    ]
                )
            ],
            onNewGame: {},
            onContinue: {}
        )
    }
}

#Preview("Multiple Wins") {
    ZStack {
        Color.gray.ignoresSafeArea()
        
        VictoryOverlayView(
            winningPatterns: [
                WinningPattern(
                    type: .horizontal(row: 0),
                    positions: [
                        GridPosition(row: 0, column: 0),
                        GridPosition(row: 0, column: 1),
                        GridPosition(row: 0, column: 2),
                        GridPosition(row: 0, column: 3),
                        GridPosition(row: 0, column: 4)
                    ]
                ),
                WinningPattern(
                    type: .vertical(column: 2),
                    positions: [
                        GridPosition(row: 0, column: 2),
                        GridPosition(row: 1, column: 2),
                        GridPosition(row: 2, column: 2),
                        GridPosition(row: 3, column: 2),
                        GridPosition(row: 4, column: 2)
                    ]
                )
            ],
            onNewGame: {},
            onContinue: {}
        )
    }
}

#Preview("Large Text") {
    ZStack {
        Color.gray.ignoresSafeArea()
        
        VictoryOverlayView(
            winningPatterns: [
                WinningPattern(
                    type: .horizontal(row: 0),
                    positions: [
                        GridPosition(row: 0, column: 0),
                        GridPosition(row: 0, column: 1),
                        GridPosition(row: 0, column: 2),
                        GridPosition(row: 0, column: 3),
                        GridPosition(row: 0, column: 4)
                    ]
                )
            ],
            onNewGame: {},
            onContinue: {}
        )
    }
    .environment(\.sizeCategory, .accessibilityExtraLarge)
} 