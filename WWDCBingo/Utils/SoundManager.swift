import Foundation
import AVFoundation
import AudioToolbox
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    @Published var isSoundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isSoundEnabled, forKey: "NSLondonDubDub25_SoundEnabled")
        }
    }
    
    private init() {
        self.isSoundEnabled = UserDefaults.standard.object(forKey: "NSLondonDubDub25_SoundEnabled") as? Bool ?? true
    }
    
    // MARK: - Public Methods
    
    func playVictorySound() {
        guard isSoundEnabled else { return }
        
        // Use system sound for victory celebration
        // Fanfare is a more celebratory sound for winning
        AudioServicesPlaySystemSound(1016) // Fanfare sound
    }
    
    func playTileSelectionFeedback() {
        guard isSoundEnabled else { return }
        
        // Play a subtle tap sound for tile selection
        AudioServicesPlaySystemSound(1104) // Photo Shutter sound - subtle and appropriate
        
        #if canImport(UIKit)
        // Medium haptic feedback for tile selection
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        #endif
    }
    
    func playVictoryHapticFeedback() {
        guard isSoundEnabled else { return }
        
        #if canImport(UIKit)
        // Success notification haptic for victory
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        #endif
    }
    
    // Legacy method names for compatibility
    func playTileSelectSound() {
        // Optional: could add a subtle tile tap sound here
    }
    
    func playTileSelectHaptic() {
        playTileSelectionFeedback()
    }
    
    func playVictoryHaptic() {
        playVictoryHapticFeedback()
    }
    
    func toggleSound() {
        isSoundEnabled.toggle()
        
        // Play a test sound when enabling
        if isSoundEnabled {
            AudioServicesPlaySystemSound(1016) // Fanfare sound
        }
    }
}

// MARK: - System Sound IDs Reference
/*
 Common iOS System Sound IDs:
 1000 - New Mail
 1001 - Mail Sent
 1002 - Voicemail
 1003 - SMS Received 1
 1004 - SMS Received 2
 1005 - SMS Received 3
 1006 - SMS Received 4
 1007 - SMS Received 5
 1008 - SMS Received 6
 1009 - Anticipate
 1010 - Bloom
 1011 - Calypso
 1012 - Choo Choo
 1013 - Descent
 1014 - Fanfare
 1015 - Ladder
 1016 - Minuet
 1017 - News Flash
 1018 - Noir
 1019 - Sherwood Forest
 1020 - Spell
 1021 - Suspense
 1022 - Telegraph
 1023 - Tiptoes
 1024 - Typewriters
 1025 - Update
 1057 - SMS Alert (iOS 7+)
 1104 - Photo Shutter
 */ 