//
//  LumonCursor.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 09.03.2025.
//

import SwiftUI
import AppKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Default Cursor Area")
                .padding()
            CustomCursorView {
                Text("Custom Cursor Area")
                    .padding()
            }
            .onHover { _ in
                NSCursor.init(image: NSImage.cursor, hotSpot: .zero).set()
            }
        }
        .frame(width: 400, height: 300)
    }
}

struct CustomCursorView<Content: View>: NSViewRepresentable {
    var content: () -> Content
    // Create a custom cursor from an image.
    let customCursor: NSCursor = {
        let image = NSImage(named: NSImage.Name("LOGO")) ?? NSImage()
        // Define the hotspot as the center of the image.
        return NSCursor(image: image, hotSpot: NSPoint(x: image.size.width/2, y: image.size.height/2))
    }()

    func makeNSView(context: Context) -> NSHostingView<Content> {
        let hostingView = NSHostingView(rootView: content())
        // Add a tracking area so that we can change the cursor on hover.
        let trackingArea = NSTrackingArea(
            rect: hostingView.bounds,
            options: [.activeAlways, .mouseEnteredAndExited, .inVisibleRect],
            owner: context.coordinator,
            userInfo: nil
        )
        hostingView.addTrackingArea(trackingArea)
        return hostingView
    }

    func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {
        nsView.rootView = content()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(customCursor: customCursor)
    }

    class Coordinator: NSObject {
        let customCursor: NSCursor

        init(customCursor: NSCursor) {
            self.customCursor = customCursor
        }

//        override func mouseEntered(with event: NSEvent) {
//            customCursor.set()
//        }
//
//        override func mouseExited(with event: NSEvent) {
//            NSCursor.arrow.set()
//        }
    }
}

#Preview {
    ContentView()
}
