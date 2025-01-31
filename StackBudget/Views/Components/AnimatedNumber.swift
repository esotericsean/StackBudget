import SwiftUI

struct AnimatedNumber: View {
    let value: Double
    let format: (Double) -> String
    
    @State private var animatedValue: Double
    
    init(value: Double, format: @escaping (Double) -> String) {
        self.value = value
        self.format = format
        self._animatedValue = State(initialValue: value)
    }
    
    var body: some View {
        Text(format(animatedValue))
            .onChange(of: value) { newValue in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    animatedValue = newValue
                }
            }
    }
}

// Add ViewModifier to support font and color modifiers
extension AnimatedNumber {
    func foregroundColor(_ color: Color) -> some View {
        Text(format(animatedValue))
            .foregroundColor(color)
            .onChange(of: value) { newValue in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    animatedValue = newValue
                }
            }
    }
    
    func font(_ font: Font) -> some View {
        Text(format(animatedValue))
            .font(font)
            .onChange(of: value) { newValue in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    animatedValue = newValue
                }
            }
    }
} 