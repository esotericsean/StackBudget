import SwiftUI

struct ColorPickerItem: View {
    let color: Color
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var scale: CGFloat = 1
    
    var body: some View {
        VStack {
            Circle()
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(AppTheme.primaryColor, lineWidth: isSelected ? 3 : 0)
                )
                .shadow(color: .black.opacity(0.1), radius: 3, y: 1)
                .scaleEffect(scale)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: scale)
            
            Text(name)
                .font(AppTheme.subheadlineFont)
                .foregroundColor(.secondary)
        }
        .onTapGesture {
            scale = 0.8
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                action()
                scale = 1
            }
        }
    }
} 