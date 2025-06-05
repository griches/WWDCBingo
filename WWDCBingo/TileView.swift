import SwiftUI
import Foundation

struct TileView: View {
    let text: String
    let isSelected: Bool
    let isWinning: Bool
    let onTap: () -> Void
    
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
                .font(.system(size: dynamicFontSize, weight: .medium, design: .rounded))
                .foregroundColor(textColor)
                .multilineTextAlignment(.center)
                .lineLimit(5)
                .minimumScaleFactor(0.4)
                .padding(4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(tileBackground)
                .overlay(tileOverlay)
        }
        .aspectRatio(1.0, contentMode: .fit)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.3), value: isWinning)
    }
    
    // MARK: - Computed Properties
    
    private var textColor: Color {
        if isWinning {
            return .white
        } else if isSelected {
            return .white
        } else {
            return .primary
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
            // Gold gradient for winning tiles
            return LinearGradient(
                colors: [.yellow, .orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else if isSelected {
            // Blue gradient for selected tiles
            return LinearGradient(
                colors: [.blue, .blue.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            // Default background for unselected tiles
            return LinearGradient(
                colors: [Color(.systemBackground)],
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
            return .gray.opacity(0.2)
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
            .stroke(
                isSelected || isWinning ? .clear : Color(.systemGray4),
                lineWidth: 1
            )
    }
}

#Preview {
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