//
//  SearchBarView.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    let searchResults: [CityEntity]
    let isSearching: Bool
    let onCitySelected: (CityEntity) -> Void
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Search input field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search US city...", text: $searchText)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()
                    .focused($isTextFieldFocused)
                    .accessibilityIdentifier(AccessibilityID.searchTextField)
                    .accessibilityLabel("Search city")
                    .accessibilityHint("Enter a US city name to search for weather")
                
                // Clear button
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        isTextFieldFocused = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .frame(width: 24, height: 24) // Ensure tappable area
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier(AccessibilityID.searchClearButton)
                    .accessibilityLabel("Clear search")
                }
                
                // Loading indicator
                if isSearching {
                    ProgressView()
                        .accessibilityIdentifier(AccessibilityID.searchLoadingIndicator)
                        .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
                        .scaleEffect(0.8)
                }
            }
            .padding(12)
            .background(.regularMaterial)
            .cornerRadius(12)
            
            // Search results dropdown
            if !searchResults.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(searchResults.enumerated()), id: \.offset) { index, city in
                        Button {
                            onCitySelected(city)
                            isTextFieldFocused = false
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(city.name)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    Text(citySubtitle(city))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                        }
                        .accessibilityIdentifier(AccessibilityID.searchResultCell(index: index))
                        .accessibilityLabel("\(city.name), \(citySubtitle(city))")
                        .accessibilityHint("Double tap to view weather")
                        
                        if city.latitude != searchResults.last?.latitude {
                            Divider()
                        }
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
            }
        }
    }
    
    /// Formats "state, country" or just "country" for non-US cities
    private func citySubtitle(_ city: CityEntity) -> String {
        if let state = city.state, !state.isEmpty {
            return "\(state), \(city.country)"
        }
        return city.country
    }
}
