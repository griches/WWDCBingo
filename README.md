# WWDC 2025 Bingo

A SwiftUI app for playing bingo during WWDC keynotes. Tap the squares as WWDC moments happen during the presentation!

## Current Status: Task 4 Complete ✅

### Completed Features

**Tasks 1-4: Core Foundation & Data Models**
- ✅ Basic SwiftUI app foundation with navigation
- ✅ Welcome screen with WWDC branding and "Start New Game" button
- ✅ Interactive 5×5 bingo grid with tap-to-select functionality
- ✅ **NEW: Proper data models and randomization system**
  - `BingoTile` data model with term, position, and selection state
  - `GridPosition` structure for 5×5 grid coordinates
  - `TermsDatabase` with all 25 official WWDC terms
  - Randomized grid generation on each new game

### Key Features
- **Responsive Design**: Optimized tile sizes for all iPhone screen sizes
- **Interactive Grid**: Tap squares to mark them as they happen during WWDC
- **Haptic Feedback**: Satisfying tactile response when selecting tiles
- **Visual Feedback**: Selected tiles have blue gradient backgrounds and glow effects
- **Dynamic Text Sizing**: Font automatically adjusts based on text length
- **New Game Function**: "New Game" button randomizes the grid layout
- **All 25 WWDC Terms**: Complete collection including classics like "One more thing", "You're going to love it", and modern favorites

### Technical Implementation
- **Architecture**: MVVM pattern with SwiftUI
- **Data Storage**: In-memory array storage (UserDefaults persistence coming in Task 8)
- **Grid System**: 5×5 LazyVGrid with GeometryReader for maximum tile sizing
- **Animation**: Smooth transitions for tile selection states
- **Accessibility**: Ready for VoiceOver and Dynamic Type support

### Build Requirements
- iOS 18.0+
- Xcode 16.0+
- SwiftUI

### Next Steps (Tasks 5-10)
- Pattern detection logic (rows, columns, diagonals)
- Victory celebration with confetti animation
- Game state management and persistence
- Enhanced accessibility features
- Testing and optimization

## Development Progress

This app is being built incrementally following the Software Requirements Document (SRD). Each task results in a fully compilable app with new functionality.

**Progress: 4/10 tasks complete (40%)**

## Running the App

1. Open `WWDCBingo.xcodeproj` in Xcode
2. Select an iOS Simulator (iPhone 16 recommended)
3. Build and run (`⌘+R`)
4. Tap "Start New Game" on the welcome screen
5. Start tapping squares as WWDC moments happen!

---

Built for WWDC 2025 enthusiasts who want to make the keynote even more interactive and fun! 🎯 