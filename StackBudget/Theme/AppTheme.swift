import SwiftUI

enum AppTheme {
    static let primaryColor = Color(red: 0.33, green: 0.43, blue: 0.96)  // Cheerful blue
    static let successColor = Color(red: 0.20, green: 0.80, blue: 0.51)  // Fresh green
    static let warningColor = Color(red: 0.95, green: 0.35, blue: 0.35)  // Soft red
    
    static let cardBackground = Color(red: 0.98, green: 0.98, blue: 1.0)
    static let surfaceBackground = Color(red: 0.96, green: 0.96, blue: 0.98)
    
    // Custom font sizes
    static let titleFont = Font.system(.title, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let subheadlineFont = Font.system(.subheadline, design: .rounded)
    
    // Animation durations
    static let quickAnimation = 0.3
    static let standardAnimation = 0.4
    
    // Standard spacing
    static let spacing: CGFloat = 16
    static let smallSpacing: CGFloat = 8
    static let largeSpacing: CGFloat = 24
    
    // Card styling
    static func cardStyle<Content: View>(_ content: Content) -> some View {
        content
            .padding()
            .background(cardBackground)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    // Button styling
    static func primaryButton<Content: View>(_ content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(primaryColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: primaryColor.opacity(0.3), radius: 5, y: 2)
    }
    
    // Success/failure animations
    static func successAnimation(_ value: Bool) -> Animation {
        .spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.3)
    }
}

// Custom modifiers
struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppTheme.cardBackground)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

extension View {
    func card() -> some View {
        modifier(CardModifier())
    }
    
    func shake(trigger: Bool) -> some View {
        modifier(ShakeEffect(animatableData: trigger ? 1 : 0))
    }
} 
