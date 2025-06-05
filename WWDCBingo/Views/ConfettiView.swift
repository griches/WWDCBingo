import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    @State private var animationTimer: Timer?
    
    // Accessibility support
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    let isActive: Bool
    let duration: Double
    
    init(isActive: Bool, duration: Double = 3.0) {
        self.isActive = isActive
        self.duration = duration
    }
    
    var body: some View {
        ZStack {
            if !reduceMotion {
                // Full confetti animation for users who don't have reduced motion
                ForEach(particles) { particle in
                    Rectangle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .rotationEffect(.degrees(particle.rotation))
                        .position(x: particle.x, y: particle.y)
                        .opacity(particle.opacity)
                }
            } else {
                // Simple celebration indicator for reduced motion users
                if isActive {
                    VStack {
                        Image(systemName: "party.popper.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.yellow, .orange)
                            .scaleEffect(1.2)
                            .animation(.easeInOut(duration: 0.5).repeatCount(3), value: isActive)
                        
                        Text("🎉 Celebration! 🎉")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .opacity(0.8)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .allowsHitTesting(false) // Don't interfere with taps
        .accessibilityHidden(true) // Hide decorative confetti from screen readers
        .onChange(of: isActive) { _, newValue in
            if newValue {
                startConfetti()
            } else {
                stopConfetti()
            }
        }
        .onDisappear {
            stopConfetti()
        }
    }
    
    private func startConfetti() {
        guard particles.isEmpty else { return }
        
        // Generate initial burst of particles
        generateParticles(count: 50)
        
        // Start animation timer
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            updateParticles()
        }
        
        // Stop after duration
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            stopConfetti()
        }
    }
    
    private func stopConfetti() {
        animationTimer?.invalidate()
        animationTimer = nil
        
        // Fade out remaining particles
        withAnimation(.easeOut(duration: 1.0)) {
            for index in particles.indices {
                particles[index].opacity = 0
            }
        }
        
        // Clear particles after fade
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            particles.removeAll()
        }
    }
    
    private func generateParticles(count: Int) {
        let screenWidth = UIScreen.main.bounds.width
        
        for _ in 0..<count {
            let particle = ConfettiParticle(
                x: Double.random(in: 0...screenWidth),
                y: -20, // Start above screen
                velocityX: Double.random(in: -50...50),
                velocityY: Double.random(in: 50...150),
                size: Double.random(in: 4...12),
                color: ConfettiParticle.randomColor(),
                rotation: Double.random(in: 0...360),
                rotationSpeed: Double.random(in: -5...5)
            )
            particles.append(particle)
        }
    }
    
    private func updateParticles() {
        let screenHeight = UIScreen.main.bounds.height
        
        for index in particles.indices.reversed() {
            // Update physics
            particles[index].y += particles[index].velocityY * 0.016
            particles[index].x += particles[index].velocityX * 0.016
            particles[index].rotation += particles[index].rotationSpeed * 0.016
            
            // Apply gravity
            particles[index].velocityY += 200 * 0.016 // Gravity acceleration
            
            // Add some air resistance
            particles[index].velocityX *= 0.998
            particles[index].velocityY *= 0.998
            
            // Fade out as they fall
            let fallProgress = particles[index].y / screenHeight
            particles[index].opacity = max(0, 1.0 - fallProgress * 1.5)
            
            // Remove particles that have fallen off screen or faded out
            if particles[index].y > screenHeight + 50 || particles[index].opacity <= 0 {
                particles.remove(at: index)
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double
    var velocityX: Double
    var velocityY: Double
    let size: Double
    let color: Color
    var rotation: Double
    let rotationSpeed: Double
    var opacity: Double = 1.0
    
    static func randomColor() -> Color {
        let colors: [Color] = [
            .blue, .green, .orange, .pink, .purple, .red, .yellow,
            .cyan, .mint, .indigo, .teal
        ]
        return colors.randomElement() ?? .blue
    }
}

#Preview("Confetti Active") {
    ZStack {
        Color.black.ignoresSafeArea()
        ConfettiView(isActive: true)
    }
}

#Preview("Confetti Inactive") {
    ZStack {
        Color.black.ignoresSafeArea()
        ConfettiView(isActive: false)
    }
} 