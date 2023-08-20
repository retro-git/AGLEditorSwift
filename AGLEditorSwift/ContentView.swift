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
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .onChange(of: selectedMode) { newValue in
            // When selectedMode changes, recompile the text with the new mode
            compiledText = compileFfi(source: editorText, mode: newValue)
        }
        .accessibilityIdentifier("modePicker")
        
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Left Side TextEditor
                TextEditor(text: $editorText)
                    .frame(width: dividerPosition * geometry.size.width)
                    .border(Color.gray)
                    .disableAutocorrection(true)
                    .padding()
                    .font(.system(size: 16))
                    .onChange(of: editorText) { newValue in
                        compiledText = compileFfi(source: newValue, mode: selectedMode)
                    }
                    .accessibilityIdentifier("inputEditor")
                
                Resizer()
                
                // Button that copies compiledText to clipboard, both on Mac and iPad
                Button(action: {
                    #if os(macOS)
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(compiledText, forType: .string)
                    #else
                    UIPasteboard.general.string = compiledText
                    #endif
                }) {
                    Image(systemName: "doc.on.doc")
                        .padding()
                }
                
                // Right Side TextEditor (Read-Only)
                TextEditor(text: $compiledText)
                    .frame(width: (1 - dividerPosition) * geometry.size.width - 70)
                    .border(Color.gray)
                    .padding()
                    .font(.system(size: 16))
                    .disabled(true)
                    .accessibilityIdentifier("outputEditor")
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
}

struct Resizer: View {
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .frame(width: 8, height: .infinity)
            .cornerRadius(10)
    }
}
