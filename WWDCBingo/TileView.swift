import SwiftUI
import Foundation

struct TileView: View {
    let text: String
    let isSelected: Bool
    let isWinning: Bool
    let onTap: () -> Void
    
    // Accessibility and environment support
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    
    // Convenience initializer for current usage (without winning state)
    init(text: String, isSelected: Bool, onTap: @escaping () -> Void) {
        self.text = text
        self.isSelected = isSelected
        self.isWinning = false
        self.onTap = onTap
    }
    
    // Full initializer for future use with winning patterns
    init(text: String, isSelected: Bool, isWinning: Bool, onTap: @escaping () -> Void) {
        self.text = text
        self.isSelected = isSelected
        self.isWinning = isWinning
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: onTap) {
            Text(text)
                .font(scaledFont)
                .foregroundColor(textColor)
                .multilineTextAlignment(.center)
                .lineLimit(accessibilityLineLimit)
                .minimumScaleFactor(minimumScaleFactor)
                .padding(4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(tileBackground)
                .overlay(tileOverlay)
        }
        .aspectRatio(1.0, contentMode: .fit)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityValue(accessibilityValue)
        .accessibilityAddTraits(accessibilityTraits)
        .accessibilityAction(.default) {
            onTap()
        }
        .animation(
            reduceMotion ? .none : .easeInOut(duration: 0.2),
            value: isSelected
        )
        .animation(
            reduceMotion ? .none : .easeInOut(duration: 0.3),
            value: isWinning
        )
    }
    
    // MARK: - Dynamic Type Support
    
    private var scaledFont: Font {
        // Scale font based on accessibility text size
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return .system(size: 12, weight: .medium, design: .rounded)
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .system(size: 10, weight: .medium, design: .rounded)
        default:
            return .system(size: dynamicFontSize, weight: .medium, design: .rounded)
        }
    }
    
    private var accessibilityLineLimit: Int {
        sizeCategory.isAccessibilityCategory ? 10 : 5
    }
    
    private var minimumScaleFactor: CGFloat {
        sizeCategory.isAccessibilityCategory ? 0.6 : 0.4
    }
    
    // MARK: - High Contrast Support
    
    private var textColor: Color {
        if isWinning {
            return differentiateWithoutColor ? .black : .white
        } else if isSelected {
            return .white
        } else {
            return colorScheme == .dark ? .white : .black
        }
    }
    
    private var dynamicFontSize: CGFloat {
        let textLength = text.count
        if textLength <= 8 {
            return 16
        } else if textLength <= 15 {
            return 14
        } else if textLength <= 25 {
            return 12
        } else if textLength <= 35 {
            return 10
        } else {
            return 8
        }
    }
    
    private var tileBackground: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(backgroundGradient)
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: 0,
                y: shadowOffset
            )
    }
    
    private var backgroundGradient: LinearGradient {
        if isWinning {
            // High contrast gold for winning tiles
            if differentiateWithoutColor {
                return LinearGradient(
                    colors: [Color.yellow.opacity(0.9), Color.orange.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                return LinearGradient(
                    colors: [.yellow, .orange],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        } else if isSelected {
            // Enhanced contrast for selected tiles
            return LinearGradient(
                colors: differentiateWithoutColor ? 
                    [.blue.opacity(0.9), .blue.opacity(0.7)] :
                    [.blue, .blue.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            // Default background with better contrast
            let baseColor = colorScheme == .dark ? 
                Color(.systemGray6) : 
                Color(.systemBackground)
            return LinearGradient(
                colors: [baseColor],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var shadowColor: Color {
        if isWinning {
            return .yellow.opacity(0.4)
        } else if isSelected {
            return .blue.opacity(0.3)
        } else {
            return Color(.systemGray4).opacity(0.3)
        }
    }
    
    private var shadowRadius: CGFloat {
        if isWinning {
            return 6
        } else if isSelected {
            return 4
        } else {
            return 2
        }
    }
    
    private var shadowOffset: CGFloat {
        if isWinning || isSelected {
            return 2
        } else {
            return 1
        }
    }
    
    private var tileOverlay: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(borderColor, lineWidth: borderWidth)
    }
    
    // Enhanced border for high contrast and differentiation
    private var borderColor: Color {
        if differentiateWithoutColor {
            if isWinning {
                return .orange
            } else if isSelected {
                return .blue
            } else {
                return Color(.systemGray3)
            }
        } else {
            return isSelected || isWinning ? .clear : Color(.systemGray4)
        }
    }
    
    private var borderWidth: CGFloat {
        if differentiateWithoutColor {
            return isWinning ? 3.0 : (isSelected ? 2.0 : 1.0)
        } else {
            return 1.0
        }
    }
    
    // MARK: - Accessibility Support
    
    private var accessibilityLabel: String {
        return text
    }
    
    private var accessibilityHint: String {
        if isWinning {
            return "This tile is part of a winning bingo pattern"
        } else if isSelected {
            return "Double tap to deselect this bingo term"
        } else {
            return "Double tap to select this bingo term"
        }
    }
    
    private var accessibilityValue: String {
        var components: [String] = []
        
        if isSelected {
            components.append("Selected")
        }
        
        if isWinning {
            components.append("Part of winning pattern")
        }
        
        return components.isEmpty ? "Not selected" : components.joined(separator: ", ")
    }
    
    private var accessibilityTraits: AccessibilityTraits {
        var traits: AccessibilityTraits = []
        
        if isSelected {
            _ = traits.insert(.isSelected)
        }
        
        return traits
    }
}

#Preview("Accessibility Sizes") {
    VStack(spacing: 10) {
        HStack(spacing: 10) {
            TileView(text: "One more thing", isSelected: false) { }
                .frame(width: 120, height: 120)
            
            TileView(text: "You're going to love it", isSelected: true) { }
                .frame(width: 120, height: 120)
        }
        
        HStack(spacing: 10) {
            TileView(text: "Camera zooming around Apple Park", isSelected: false) { }
                .frame(width: 120, height: 120)
            
            TileView(text: "iOS 26", isSelected: false, isWinning: true) { }
                .frame(width: 120, height: 120)
        }
        
        TileView(text: "A video of apps saving lives across the world and making a difference", isSelected: false) { }
            .frame(width: 140, height: 140)
    }
    .padding()
} 