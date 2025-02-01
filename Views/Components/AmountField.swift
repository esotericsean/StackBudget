import SwiftUI

struct AmountField: View {
    @Binding var text: String
    let placeholder: String
    
    @State private var isEditing: Bool = false
    @State private var previousAmount: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            .focused($isFocused)
            .onTapGesture {
                if !isEditing {
                    previousAmount = text
                    text = ""
                    isEditing = true
                    isFocused = true
                }
            }
            .onChange(of: isFocused) { focused in
                if focused {
                    if !isEditing {
                        previousAmount = text
                        text = ""
                        isEditing = true
                    }
                } else if isEditing {
                    if text.isEmpty {
                        text = previousAmount
                    }
                    isEditing = false
                }
            }
            .onAppear {
                previousAmount = text
                // Auto-focus when view appears
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isFocused = true
                }
            }
    }
} 