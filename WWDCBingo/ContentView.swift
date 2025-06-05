//
//  ContentView.swift
//  WWDCBingo
//
//  Created by Riches, Gary (G.) on 05/06/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // App Icon/Logo Area
                Image(systemName: "checkmark.rectangle.stack.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue.gradient)
                
                // App Title
                VStack(spacing: 8) {
                    Text("WWDC 2025")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Bingo")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                
                // Subtitle
                Text("Interactive Keynote Companion")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                // Version Info
                Text("Version 1.0")
                    .font(.caption)
                    .foregroundColor(.secondary.opacity(0.7))
            }
            .padding()
            .navigationTitle("WWDC Bingo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
