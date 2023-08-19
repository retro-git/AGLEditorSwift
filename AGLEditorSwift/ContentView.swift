import SwiftUI

struct ContentView: View {
    @State private var editorText = ""
    @State private var compiledText = ""
    @State private var dividerPosition: CGFloat = 0.5 // Initial position of the divider
    @State private var selectedMode: Mode = .psx
    
    var body: some View {
        // Mode Picker
        Picker("Select Mode", selection: $selectedMode) {
            Text("PSX").tag(Mode.psx)
            Text("N64").tag(Mode.n64)
            // Add more mode options here as needed
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .onChange(of: selectedMode) { newValue in
            // When selectedMode changes, recompile the text with the new mode
            compiledText = compileFfi(source: editorText, mode: newValue)
        }
        
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Left Side TextEditor
                TextEditor(text: $editorText)
                    .frame(width: dividerPosition * geometry.size.width)
                    .border(Color.gray)
                    .disableAutocorrection(true)
                    .padding()
                    .font(.system(size: 16)) // Set the desired font size here
                    .onChange(of: editorText) { newValue in
                        // Update the rightText with the uppercase version of userInput
                        compiledText = compileFfi(source: newValue, mode: selectedMode)
                    }
                
                Resizer()
                
                // Right Side TextEditor (Read-Only)
                TextEditor(text: $compiledText)
                    .frame(width: (1 - dividerPosition) * geometry.size.width - 70)
                    .border(Color.gray)
                    .padding()
                    .font(.system(size: 16)) // Set the desired font size here
                    .disabled(true)
            }
            
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Calculate the new divider position
                        let newDividerPosition = max(0.2, min(0.8, value.location.x / geometry.size.width))
                        
                        // Update the divider position smoothly
                        withAnimation(.easeInOut(duration: 0.1))  {
                            dividerPosition = newDividerPosition
                        }
                    }
                
            )
        }
    }
//
//    func screenWidth() -> CGFloat {
//        let width: CGFloat
//        #if os(macOS)
//        width = NSScreen.main?.frame.width ?? 800 // Default to 800 if NSScreen is not available
//        #else
//        width = UIScreen.main.bounds.width
//        #endif
//        return width / 2
//    }
}

struct Resizer: View {
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .frame(width: 8, height: .infinity)
            .cornerRadius(10)
    }
}
