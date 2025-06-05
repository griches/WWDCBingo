# Software Requirements Document (SRD)
## WWDC 2025 Bingo iOS App

**Version:** 1.0  
**Date:** December 2024  
**Technical Lead:** iOS Engineering Team  
**Status:** Draft  
**Based on:** PRD v1.0

---

## System Overview

The WWDC 2025 Bingo iOS application is implemented as a native Swift/SwiftUI application following MVVM architecture pattern. The system operates entirely offline with embedded data storage and provides real-time pattern matching for bingo gameplay.

### System Context
- **Runtime Environment**: iOS 17.0+ on iPhone and iPad devices
- **Dependencies**: iOS Foundation, SwiftUI, Core Animation frameworks
- **Data Dependencies**: Local embedded bingo terms array
- **Network Dependencies**: None (offline-first design)

---

## Software Architecture

### Architecture Pattern: MVVM (Model-View-ViewModel)

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Views       │    │   ViewModels    │    │     Models      │
│                 │    │                 │    │                 │
│ • WelcomeView   │◄──►│ • GameViewModel │◄──►│ • BingoGame     │
│ • GameView      │    │ • SettingsVM    │    │ • BingoTile     │
│ • TileView      │    │                 │    │ • GameState     │
│ • ConfettiView  │    │                 │    │ • TermsDatabase │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Core Components

#### 1. Application Layer
- **App.swift**: SwiftUI App entry point
- **ContentView.swift**: Root navigation container
- **AppDelegate.swift**: iOS lifecycle management (if needed)

#### 2. Presentation Layer
- **WelcomeView.swift**: Initial welcome screen UI
- **GameView.swift**: Main bingo grid interface
- **TileView.swift**: Individual bingo tile component
- **ConfettiView.swift**: Victory celebration animation
- **SettingsView.swift**: Optional configuration interface

#### 3. Business Logic Layer
- **GameViewModel.swift**: Game state management and business logic
- **SettingsViewModel.swift**: App configuration management
- **PatternDetector.swift**: Bingo pattern recognition algorithm
- **AnimationController.swift**: Celebration animation coordination

#### 4. Data Layer
- **BingoGame.swift**: Core game model
- **BingoTile.swift**: Individual tile data structure
- **TermsDatabase.swift**: Bingo terms storage and retrieval
- **GameState.swift**: Persistent game state model

---

## Data Models and Structures

#### BingoGame
```swift
struct BingoGame {
    let id: UUID
    var grid: [[BingoTile]]
    var gameState: GameState
    var winningPatterns: [WinningPattern]
    var createdAt: Date
    
    static let gridSize = 5
}
```

#### BingoTile
```swift
struct BingoTile: Identifiable, Hashable {
    let id: UUID
    let text: String
    var isSelected: Bool
    let position: GridPosition
    var isPartOfWinningPattern: Bool
}

struct GridPosition: Hashable {
    let row: Int
    let column: Int
}
```

#### GameState
```swift
enum GameState {
    case initialized
    case playing
    case bingo(patterns: [WinningPattern])
    case completed
}
```

#### WinningPattern
```swift
struct WinningPattern: Identifiable {
    let id: UUID
    let type: PatternType
    let positions: [GridPosition]
    let detectedAt: Date
}

enum PatternType: CaseIterable {
    case horizontal(row: Int)
    case vertical(column: Int)
    case diagonalTopLeft
    case diagonalTopRight
}
```

### Terms Database Structure

#### TermsDatabase
```swift
class TermsDatabase: ObservableObject {
    private let allTerms: [String]
    
    init() {
        allTerms = [
            "One more thing",
            "You're going to love it",
            "Camera zooming around Apple Park",
            "Someone on a roof",
            "Emotional Steve mention",
            "Xcode for iPad",
            "AI chat in Xcode",
            "iOS 26",
            "Joke about Craig",
            "GOOD MORNEENG",
            "Ford mentioned",
            "Most immersive ever",
            "Update is available RIGHT NOW",
            "Hair Force One",
            "New Icons",
            "A Sherlocking",
            "Our biggest update ever!",
            "AAA Game",
            "Old Game out on macOS",
            "Unified Experience",
            "Only Apple can do this",
            "Android Trash Talk",
            "10x",
            "Announcement for late 25",
            "A video of apps saving lives"
        ]
    }
    
    func generateRandomTerms(count: Int) -> [String]
    func getAllTerms() -> [String]
}
```

---

## Algorithm Specifications

### Grid Generation Algorithm

```swift
func generateBingoGrid() -> [[BingoTile]] {
    let selectedTerms = termsDatabase.generateRandomTerms(count: 25)
    var grid: [[BingoTile]] = []
    var termIndex = 0
    
    for row in 0..<5 {
        var rowTiles: [BingoTile] = []
        for column in 0..<5 {
            let tile = BingoTile(
                id: UUID(),
                text: selectedTerms[termIndex],
                isSelected: false,
                position: GridPosition(row: row, column: column),
                isPartOfWinningPattern: false
            )
            rowTiles.append(tile)
            termIndex += 1
        }
        grid.append(rowTiles)
    }
    return grid
}
```

### Pattern Detection Algorithm

```swift
class PatternDetector {
    func detectWinningPatterns(in grid: [[BingoTile]]) -> [WinningPattern] {
        var patterns: [WinningPattern] = []
        
        // Check horizontal patterns
        for row in 0..<5 {
            if checkHorizontalLine(grid: grid, row: row) {
                patterns.append(createHorizontalPattern(row: row))
            }
        }
        
        // Check vertical patterns
        for column in 0..<5 {
            if checkVerticalLine(grid: grid, column: column) {
                patterns.append(createVerticalPattern(column: column))
            }
        }
        
        // Check diagonal patterns
        if checkDiagonalTopLeft(grid: grid) {
            patterns.append(createDiagonalTopLeftPattern())
        }
        
        if checkDiagonalTopRight(grid: grid) {
            patterns.append(createDiagonalTopRightPattern())
        }
        
        return patterns
    }
    
    private func checkHorizontalLine(grid: [[BingoTile]], row: Int) -> Bool {
        return grid[row].allSatisfy { $0.isSelected }
    }
    
    private func checkVerticalLine(grid: [[BingoTile]], column: Int) -> Bool {
        return (0..<5).allSatisfy { row in grid[row][column].isSelected }
    }
    
    private func checkDiagonalTopLeft(grid: [[BingoTile]]) -> Bool {
        return (0..<5).allSatisfy { i in grid[i][i].isSelected }
    }
    
    private func checkDiagonalTopRight(grid: [[BingoTile]]) -> Bool {
        return (0..<5).allSatisfy { i in grid[i][4-i].isSelected }
    }
}
```

### Randomization Algorithm

```swift
extension TermsDatabase {
    func generateRandomTerms(count: Int) -> [String] {
        guard count <= allTerms.count else { 
            fatalError("Requested more terms than available") 
        }
        
        var availableTerms = allTerms
        var selectedTerms: [String] = []
        
        for _ in 0..<count {
            let randomIndex = Int.random(in: 0..<availableTerms.count)
            selectedTerms.append(availableTerms.remove(at: randomIndex))
        }
        
        return selectedTerms
    }
}
```

---

## User Interface Components

### SwiftUI View Specifications

#### GameView Component
```swift
struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @State private var showingCelebration = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                titleSection
                bingoGrid
                gameControls
            }
            .padding()
            
            if showingCelebration {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
        .onReceive(viewModel.$gameState) { state in
            if case .bingo = state {
                triggerCelebration()
            }
        }
    }
    
    private var bingoGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 8) {
            ForEach(viewModel.allTiles, id: \.id) { tile in
                TileView(tile: tile) {
                    viewModel.toggleTile(at: tile.position)
                }
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}
```

#### TileView Component
```swift
struct TileView: View {
    let tile: BingoTile
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(tile.text)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(tile.isSelected ? .white : .primary)
                .multilineTextAlignment(.center)
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(tileBackground)
                .overlay(tileOverlay)
        }
        .aspectRatio(1.0, contentMode: .fit)
        .animation(.easeInOut(duration: 0.2), value: tile.isSelected)
    }
    
    private var tileBackground: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(tile.isSelected ? Color.blue : Color.gray.opacity(0.1))
    }
    
    private var tileOverlay: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(
                tile.isPartOfWinningPattern ? Color.gold : Color.clear,
                lineWidth: tile.isPartOfWinningPattern ? 3 : 0
            )
    }
}
```

---

## System Behaviors

### Application Lifecycle

#### App Launch Sequence
1. **Application Launch**
   - Initialize TermsDatabase with embedded terms array
   - Load persisted game state (if exists)
   - Present WelcomeView

2. **Game Initialization**
   - Generate new 5x5 grid with random terms
   - Initialize GameViewModel with fresh game state
   - Transition to GameView

3. **Game Progression**
   - Monitor tile selection events
   - Execute pattern detection after each selection
   - Update UI to reflect game state changes
   - Trigger celebrations for winning patterns

4. **App Backgrounding**
   - Persist current game state to UserDefaults
   - Pause any ongoing animations
   - Prepare for app suspension

5. **App Restoration**
   - Restore saved game state
   - Resume UI in previous state
   - Continue pattern detection monitoring

### Game State Transitions

```
[Initialized] ──start_game──► [Playing]
     ▲                           │
     │                           │ tile_selected
     │                           ▼
     │                    [Pattern_Check]
     │                           │
     │                    ┌──────┴──────┐
     │                    │             │
     │               no_bingo       bingo_found
     │                    │             │
     │                    ▼             ▼
     │               [Playing]     [Celebrating]
     │                                  │
     │                           continue_playing
     │                                  │
     └─────────── new_game ◄────────────┘
```

---

## Error Handling

### Error Categories and Responses

#### System Errors
- **Memory allocation failures**: Graceful degradation, disable animations
- **Array access errors**: Use default terms, notify user
- **Animation failures**: Fallback to simple state changes

#### User Input Errors
- **Invalid tile selection**: Ignore input, maintain current state
- **Rapid tap detection**: Debounce input with 100ms threshold
- **Gesture conflicts**: Prioritize tap gestures over other interactions

#### Data Integrity Errors
- **Corrupted game state**: Reset to initial state, log error
- **Missing terms data**: Use hardcoded fallback terms
- **Invalid grid configuration**: Regenerate grid with valid parameters

### Error Recovery Mechanisms

```swift
enum GameError: Error, LocalizedError {
    case gridGenerationFailed
    case patternDetectionFailed
    case stateRestorationFailed
    case animationSystemFailed
    case termsArrayEmpty
    
    var errorDescription: String? {
        switch self {
        case .gridGenerationFailed:
            return "Failed to generate bingo grid"
        case .patternDetectionFailed:
            return "Pattern detection system error"
        case .stateRestorationFailed:
            return "Could not restore previous game"
        case .animationSystemFailed:
            return "Animation system unavailable"
        case .termsArrayEmpty:
            return "No bingo terms available"
        }
    }
}

class ErrorHandler {
    static func handle(_ error: GameError) -> RecoveryAction {
        switch error {
        case .gridGenerationFailed:
            return .regenerateWithDefaults
        case .patternDetectionFailed:
            return .disablePatternDetection
        case .stateRestorationFailed:
            return .startNewGame
        case .animationSystemFailed:
            return .disableAnimations
        case .termsArrayEmpty:
            return .useHardcodedTerms
        }
    }
}
```

---

## Performance Requirements

### Response Time Specifications

| Operation | Target Time | Maximum Time |
|-----------|-------------|--------------|
| App Launch | < 1.5s | < 3.0s |
| Grid Generation | < 200ms | < 500ms |
| Tile Selection Response | < 50ms | < 100ms |
| Pattern Detection | < 10ms | < 50ms |
| Animation Start | < 16ms | < 33ms |
| State Persistence | < 100ms | < 200ms |

### Resource Utilization Limits

| Resource | Normal Operation | Peak Usage |
|----------|------------------|------------|
| Memory | < 20MB | < 35MB |
| CPU | < 15% | < 30% |
| Battery/hour | < 5% | < 10% |
| Storage | < 5MB | < 10MB |

### Optimization Strategies

#### Memory Management
```swift
class GameViewModel: ObservableObject {
    // Use weak references for delegates
    weak var animationController: AnimationController?
    
    // Lazy initialization for expensive operations
    private lazy var patternDetector = PatternDetector()
    
    // Release resources when not needed
    deinit {
        cleanupResources()
    }
    
    private func cleanupResources() {
        // Release animation resources
        // Clear cached data
        // Cancel pending operations
    }
}
```

#### Animation Performance
```swift
struct ConfettiView: View {
    @State private var particles: [Particle] = []
    let maxParticles = 50 // Limit particle count
    
    var body: some View {
        Canvas { context, size in
            // Use Canvas for efficient particle rendering
            for particle in particles {
                context.fill(
                    Circle().path(in: particle.frame),
                    with: .color(particle.color)
                )
            }
        }
        .onReceive(animationTimer) { _ in
            updateParticles() // Batch particle updates
        }
    }
}
```

---

## Security and Privacy

### Data Protection Requirements

#### Local Data Security
- **No sensitive data collection**: App collects no personal information
- **Game state encryption**: Optional encryption for saved game states
- **Secure random generation**: Use SecRandomCopyBytes for randomization
- **Memory protection**: Clear sensitive data from memory when not needed

#### Privacy Compliance
- **No network communication**: Eliminates data transmission risks
- **No analytics collection**: No user behavior tracking
- **No device fingerprinting**: No unique device identification
- **App Store privacy labels**: Accurate "No Data Collected" labeling

### Implementation Security Measures

```swift
// Secure random number generation
func generateSecureRandomIndex(max: Int) -> Int {
    var randomBytes = [UInt8](repeating: 0, count: 4)
    let result = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    
    guard result == errSecSuccess else {
        // Fallback to system random
        return Int.random(in: 0..<max)
    }
    
    let randomValue = randomBytes.withUnsafeBytes { bytes in
        bytes.bindMemory(to: UInt32.self).first ?? 0
    }
    
    return Int(randomValue) % max
}
```

---

## Quality Attributes

### Reliability Requirements
- **Crash Rate**: < 0.1% of all sessions
- **Data Integrity**: 100% accuracy in pattern detection
- **State Consistency**: No corrupted game states
- **Recovery Time**: < 2 seconds from any error state

### Usability Requirements
- **Learning Curve**: < 30 seconds to understand interface
- **Task Completion**: 95% success rate for primary actions
- **Accessibility**: 100% VoiceOver compatibility
- **Error Prevention**: Intuitive UI prevents user errors

### Maintainability Requirements
- **Code Coverage**: > 85% test coverage
- **Documentation**: 100% public API documentation
- **Modularity**: Clear separation of concerns
- **Testability**: All business logic unit testable

---

## Testing Specifications

### Unit Testing Requirements

#### Model Testing
```swift
class BingoGameTests: XCTestCase {
    func testGridGeneration() {
        let game = BingoGame()
        XCTAssertEqual(game.grid.count, 5)
        XCTAssertEqual(game.grid[0].count, 5)
        // Verify all tiles have unique terms
        let allTerms = game.grid.flatMap { $0 }.map { $0.text }
        XCTAssertEqual(Set(allTerms).count, 25)
    }
    
    func testPatternDetection() {
        var game = BingoGame()
        // Simulate horizontal bingo
        for column in 0..<5 {
            game.grid[0][column].isSelected = true
        }
        let patterns = PatternDetector().detectWinningPatterns(in: game.grid)
        XCTAssertEqual(patterns.count, 1)
        XCTAssertEqual(patterns[0].type, .horizontal(row: 0))
    }
}
```

#### ViewModel Testing
```swift
class GameViewModelTests: XCTestCase {
    var viewModel: GameViewModel!
    
    override func setUp() {
        viewModel = GameViewModel()
    }
    
    func testTileSelection() {
        let position = GridPosition(row: 0, column: 0)
        viewModel.toggleTile(at: position)
        XCTAssertTrue(viewModel.game.grid[0][0].isSelected)
    }
    
    func testGameStateTransitions() {
        XCTAssertEqual(viewModel.gameState, .playing)
        // Simulate bingo achievement
        simulateHorizontalBingo(row: 0)
        XCTAssertTrue(viewModel.gameState.isBingo)
    }
}
```

#### Terms Database Testing
```swift
class TermsDatabaseTests: XCTestCase {
    var database: TermsDatabase!
    
    override func setUp() {
        database = TermsDatabase()
    }
    
    func testTermsArrayNotEmpty() {
        let allTerms = database.getAllTerms()
        XCTAssertEqual(allTerms.count, 25)
        XCTAssertFalse(allTerms.isEmpty)
    }
    
    func testRandomTermsGeneration() {
        let randomTerms = database.generateRandomTerms(count: 25)
        XCTAssertEqual(randomTerms.count, 25)
        XCTAssertEqual(Set(randomTerms).count, 25) // All unique
    }
    
    func testRandomTermsUniqueness() {
        let firstSet = database.generateRandomTerms(count: 25)
        let secondSet = database.generateRandomTerms(count: 25)
        // While possible, very unlikely to be identical with proper randomization
        XCTAssertNotEqual(firstSet, secondSet)
    }
}
```

### Integration Testing
- **View-ViewModel Integration**: Test UI state updates
- **Animation Integration**: Verify animation triggers
- **Persistence Integration**: Test state save/restore
- **Accessibility Integration**: VoiceOver functionality

### Performance Testing
- **Memory leak detection**: Instruments profiling
- **Battery usage testing**: Energy Impact measurement
- **Animation performance**: Frame rate monitoring
- **Launch time testing**: Cold/warm start measurements

---

## Data Storage Architecture

### Simple Array-Based Storage

#### Terms Storage
```swift
struct TermsStorage {
    static let defaultTerms = [
        "One more thing",
        "You're going to love it", 
        "Camera zooming around Apple Park",
        "Someone on a roof",
        "Emotional Steve mention",
        "Xcode for iPad",
        "AI chat in Xcode",
        "iOS 26",
        "Joke about Craig",
        "GOOD MORNEENG",
        "Ford mentioned",
        "Most immersive ever",
        "Update is available RIGHT NOW",
        "Hair Force One",
        "New Icons",
        "A Sherlocking",
        "Our biggest update ever!",
        "AAA Game",
        "Old Game out on macOS",
        "Unified Experience",
        "Only Apple can do this",
        "Android Trash Talk",
        "10x",
        "Announcement for late 25",
        "A video of apps saving lives"
    ]
}
```

#### Game State Persistence
```swift
extension GameViewModel {
    func saveGameState() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(game) {
            UserDefaults.standard.set(encoded, forKey: "currentGame")
        }
    }
    
    func loadGameState() -> BingoGame? {
        guard let data = UserDefaults.standard.data(forKey: "currentGame") else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode(BingoGame.self, from: data)
    }
}
```

---

## Deployment Configuration

### Build Configurations

#### Debug Configuration
- **Optimization Level**: None (-Onone)
- **Debug Symbols**: Full debug information
- **Assertions**: Enabled
- **Logging**: Verbose logging enabled
- **Testing**: All test frameworks included

#### Release Configuration
- **Optimization Level**: Optimize for Speed (-O)
- **Debug Symbols**: Minimal symbols for crash reporting
- **Assertions**: Disabled in production code
- **Logging**: Error logging only
- **Code Signing**: Distribution certificate

### App Store Configuration
- **Bundle Identifier**: com.company.wwdcbingo2025
- **Version**: 1.0.0 (Build 1)
- **Deployment Target**: iOS 17.0
- **Device Family**: Universal (iPhone + iPad)
- **Orientation**: Portrait (primary), Landscape (supported)
- **Privacy Manifest**: No data collection declared 