import SwiftUI

extension Color {
    static let customPalette: [(main: Color, name: String)] = [
        (Color(red: 0.33, green: 0.43, blue: 0.96), "Ocean"),    // Cheerful blue
        (Color(red: 0.95, green: 0.35, blue: 0.35), "Coral"),    // Warm red
        (Color(red: 0.20, green: 0.80, blue: 0.51), "Mint"),     // Fresh green
        (Color(red: 0.95, green: 0.75, blue: 0.30), "Sunshine"), // Bright yellow
        (Color(red: 0.70, green: 0.35, blue: 0.95), "Grape"),    // Rich purple
        (Color(red: 0.95, green: 0.55, blue: 0.35), "Tangerine"),// Bright orange
        (Color(red: 0.35, green: 0.80, blue: 0.95), "Sky"),      // Light blue
        (Color(red: 0.95, green: 0.45, blue: 0.80), "Berry")     // Bright pink
    ]
    
    static func alternatingColors(for baseColor: Color, isEven: Bool) -> Color {
        let opacity = isEven ? 0.12 : 0.18
        return baseColor.opacity(opacity)
    }
    
    static var randomPaletteColor: Color {
        customPalette.randomElement()?.main ?? customPalette[0].main
    }
}

extension View {
    func hideNavigationArrow() -> some View {
        self.modifier(HideNavigationArrowModifier())
    }
}

struct HideNavigationArrowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(NavigationLink("", destination: EmptyView()).opacity(0))
    }
} 