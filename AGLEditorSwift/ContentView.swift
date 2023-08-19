import SwiftUI

struct ContentView: View {
    @State private var editorText = ""
    @State private var compiledText = ""
    @State private var dividerPosition: CGFloat = 0.5 // Initial position of the divider
    
    var body: some View {
        HStack(spacing: 0) {
            // Left Side TextEditor
            TextEditor(text: $editorText)
                .frame(width: dividerPosition * screenWidth())
                .border(Color.gray)
                .disableAutocorrection(true)
                .padding()
                .onChange(of: editorText) { newValue in
                    // Update the rightText with the uppercase version of userInput
                    compiledText = compileFfi(source: newValue, mode: Mode.psx)
                }
            
            Resizer()
            
            // Right Side TextEditor (Read-Only)
            TextEditor(text: $compiledText)
                .frame(width: (1 - dividerPosition) * screenWidth())
                .border(Color.gray)
                .padding()
                .disabled(true)
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    // Calculate the new divider position
                    let newDividerPosition = max(0.2, min(0.8, value.location.x / screenWidth()))
                    
                    // Update the divider position smoothly
                    withAnimation {
                        dividerPosition = newDividerPosition
                    }
                }
        )
    }
    
    func screenWidth() -> CGFloat {
        #if os(macOS)
        return NSScreen.main?.frame.width ?? 800 // Default to 800 if NSScreen is not available
        #else
        return UIScreen.main.bounds.width
        #endif
    }
}

struct Resizer: View {
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .frame(width: 8, height: .infinity)
            .cornerRadius(10)
    }
}
