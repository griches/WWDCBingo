import SwiftUI

struct WelcomeView: View {
    // Accessibility and environment support
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme
    @AccessibilityFocusState private var titleFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: dynamicSpacing) {
                Spacer()
                
                // App Icon/Logo Area with accessibility
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.rectangle.stack.fill")
                        .font(.system(size: iconSize))
                        .foregroundStyle(appIconGradient)
                        .symbolEffect(reduceMotion ? .bounce.byLayer : .bounce, value: 1)
                        .accessibilityLabel("NSLondon DubDub 25 app icon")
                        .accessibilityHidden(false)
                    
                    // App Title with enhanced accessibility
                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Text("NSLondon")
                                .font(scaledLargeTitleFont)
                                .fontWeight(.black)
                                .foregroundStyle(titleGradient)
                            
                            Text("DubDub")
                                .font(scaledLargeTitleFont)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("NSLondon DubDub")
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityFocused($titleFocused)
                        
                        Text("25")
                            .font(scaledTitleFont)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .tracking(2)
                            .accessibilityLabel("25 bingo game")
                    }
                }
                
                // Subtitle with enhanced accessibility
                VStack(spacing: 8) {
                    Text("Interactive Keynote Companion")
                        .font(scaledSubtitleFont)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .accessibilityLabel("Interactive keynote companion app")
                        .accessibilityAddTraits(.isHeader)
                    
                    Text("Tap a matching tile as you hear the phrase or see the event happen!")
                        .font(scaledBodyFont)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(sizeCategory.isAccessibilityCategory ? nil : 3)
                        .accessibilityLabel("Instructions: Tap a matching tile as you hear the phrase or see the event happen")
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Start Game Button with enhanced accessibility
                NavigationLink(destination: GameView()) {
                    HStack(spacing: 10) {
                        Image(systemName: "play.fill")
                            .font(scaledButtonIconFont)
                        
                        Text("Start New Game")
                            .font(scaledButtonFont)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, buttonPadding)
                    .background(buttonBackground)
                    .padding(.horizontal, 20)
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Start new bingo game")
                .accessibilityHint("Double tap to start a new bingo game with randomized terms")
                .accessibilityAddTraits(.startsMediaSession)
                
                Spacer(minLength: 20)
                
                // Footer section with credits and version
                VStack(spacing: 8) {
                    // Credits Section
                    VStack(spacing: 6) {
                        Text("Created by Gary")
                            .font(scaledSmallCaptionFont)
                            .foregroundColor(.secondary.opacity(0.6))
                            .accessibilityLabel("Created by Gary")
                        
                        Button(action: openMastodonProfile) {
                            HStack(spacing: 0) {
                                Text("@gary_bbgames")
                                Text("@")
                                Text("mstdn.games")
                            }
                            .font(scaledSmallCaptionFont)
                            .foregroundColor(.blue.opacity(0.8))
                            .underline()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("Contact Gary on Mastodon")
                        .accessibilityHint("Double tap to open Gary's Mastodon profile")
                        .accessibilityAddTraits(.isLink)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Credits: Created by Gary. Contact on Mastodon at gary bbgames on mstdn dot games")
                    
                    // Version info
                    Text("Version 1.0")
                        .font(scaledSmallCaptionFont)
                        .foregroundColor(.secondary.opacity(0.5))
                        .accessibilityLabel("Version 1.0")
                }
                
                Spacer(minLength: 20)
            }
            .padding()
            .navigationBarHidden(true)
            .onAppear {
                // Auto-focus on title for VoiceOver users
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    titleFocused = true
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Helper Functions
    
    private func openMastodonProfile() {
        // Try various Mastodon app URL schemes, fallback to web URL
        let mastodonAppURL1 = URL(string: "mastodon://profile/gary_bbgames@mstdn.games")
        let mastodonAppURL2 = URL(string: "mastodon://user?username=gary_bbgames&domain=mstdn.games")
        let webURL = URL(string: "https://mstdn.games/@gary_bbgames")
        
        // Try different Mastodon app URL formats
        if let url1 = mastodonAppURL1, UIApplication.shared.canOpenURL(url1) {
            UIApplication.shared.open(url1)
        } else if let url2 = mastodonAppURL2, UIApplication.shared.canOpenURL(url2) {
            UIApplication.shared.open(url2)
        } else if let webURL = webURL {
            // Fall back to opening in Safari
            UIApplication.shared.open(webURL)
        }
    }
    
    // MARK: - Dynamic Type Support
    
    private var scaledLargeTitleFont: Font {
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
    
    private var scaledTitleFont: Font {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return .title2
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .title3
        default:
            return .title
        }
    }
    
    private var scaledSubtitleFont: Font {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return .title3
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .headline
        default:
            return .title3
        }
    }
    
    private var scaledBodyFont: Font {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return .body
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .callout
        default:
            return .subheadline
        }
    }
    
    private var scaledButtonFont: Font {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return .headline
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .body
        default:
            return .title3
        }
    }
    
    private var scaledButtonIconFont: Font {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return .headline
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .body
        default:
            return .title3
        }
    }
    
    private var scaledCaptionFont: Font {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return .callout
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .caption
        default:
            return .caption
        }
    }
    
    private var scaledSmallCaptionFont: Font {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return .caption
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return .caption2
        default:
            return .caption2
        }
    }
    
    // MARK: - Dynamic Layout Support
    
    private var dynamicSpacing: CGFloat {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return 30
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return 20
        default:
            return 40
        }
    }
    
    private var iconSize: CGFloat {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return 80
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return 60
        default:
            return 100
        }
    }
    
    private var buttonPadding: CGFloat {
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge:
            return 20
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return 24
        default:
            return 16
        }
    }
    
    // MARK: - Color and Style Support
    
    private var appIconGradient: LinearGradient {
        LinearGradient(
            colors: [.blue, .blue.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var titleGradient: LinearGradient {
        LinearGradient(
            colors: [.blue, .blue.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                LinearGradient(
                    colors: [.blue, .blue.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

#Preview("Default") {
    WelcomeView()
}

#Preview("Large Text") {
    WelcomeView()
        .environment(\.sizeCategory, .accessibilityExtraLarge)
}

#Preview("Dark Mode") {
    WelcomeView()
        .preferredColorScheme(.dark)
} 