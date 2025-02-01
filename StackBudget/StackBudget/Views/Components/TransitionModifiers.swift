import SwiftUI

extension AnyTransition {
    static var slideUp: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        )
    }
    
    static var popUp: AnyTransition {
        .scale(scale: 0.9)
            .combined(with: .opacity)
    }
} 