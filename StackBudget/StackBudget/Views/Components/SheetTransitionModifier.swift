import SwiftUI

struct SheetTransitionModifier: ViewModifier {
    let isPresented: Binding<Bool>
    let onDismiss: (() -> Void)?
    let content: () -> any View
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: isPresented, onDismiss: onDismiss) {
                AnyView(self.content())
                    .transition(.slideUp)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPresented.wrappedValue)
            }
    }
}

extension View {
    func animatedSheet<Content: View>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(SheetTransitionModifier(
            isPresented: isPresented,
            onDismiss: onDismiss,
            content: content
        ))
    }
} 