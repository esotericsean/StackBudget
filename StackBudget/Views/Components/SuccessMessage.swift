import SwiftUI

struct SuccessMessage: View {
    var message: String = "Added Successfully!"
    
    var body: some View {
        VStack {
            Text("✓")
                .font(.system(size: 50))
                .foregroundColor(.white)
            Text(message)
                .font(AppTheme.bodyFont)
                .foregroundColor(.white)
        }
        .padding()
        .background(AppTheme.successColor)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
} 
