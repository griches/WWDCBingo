import SwiftUI

struct TileView: View {
    let text: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(text)
                .font(.system(size: dynamicFontSize, weight: .medium, design: .rounded))
                .foregroundColor(isSelected ? .white : .primary)
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
            .fill(isSelected ? 
                  LinearGradient(
                    colors: [.blue, .blue.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                  ) : 
                  LinearGradient(
                    colors: [Color(.systemBackground)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                  )
            )
            .shadow(
                color: isSelected ? .blue.opacity(0.3) : .gray.opacity(0.2),
                radius: isSelected ? 4 : 2,
                x: 0,
                y: isSelected ? 2 : 1
            )
    }
    
    private var tileOverlay: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(
                isSelected ? .clear : Color(.systemGray4),
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
            
            TileView(text: "iOS", isSelected: false) { }
                .frame(width: 120, height: 120)
        }
        
        TileView(text: "A video of apps saving lives across the world and making a difference", isSelected: false) { }
            .frame(width: 140, height: 140)
    }
    .padding()
} 