//
//  Test.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 16.03.2025.
//

import SwiftUI

struct Test: View {

    @State var rotate = false
    let colors = [Color.red, .green, .blue, .orange, .yellow]

    var body: some View {
        VStack {
            Spacer(minLength: 150)
//            ZStack {
//                ForEach(0..<colors.count) { index in
//                    let ind = colors.count - index - 1
//                    Rectangle()
//                        .fill(colors[index])
//                        .frame(width: 200, height: 100)
//                        .rotation3DEffect(
//                            .degrees(-10 * Double(ind)),
//                            axis: (x: 1, y: 0, z: 0),
//                            anchor: .bottom,
//                            perspective: 0.1
//                        )
//                }
//
//            }
////            shapedText
////                .rotation3DEffect(.degrees(rotate ? -30 : 0), axis: (x: 1, y: 0, z: 0), anchor: .top, perspective: 1)
            shapedText
                .rotation3DEffect(
                    .degrees(rotate ? -40 : 0),
                    axis: (x: 1, y: 0, z: 0),
                    anchor: .top,
                    perspective: 0.3
                )
            Spacer(minLength: 250)
            Button("Rotate") {
                withAnimation(.linear(duration: 1)) {
                    rotate.toggle()
                }
            }
        }
    }

    private var rectangles: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(.red)
                .frame(width: 200, height: 100)

            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 80)
                .zIndex(rotate ? -1 : 0)
        }
    }

    private var textInCanvas: some View {
        Canvas(
            opaque: true,
            colorMode: .linear,
            rendersAsynchronously: false
        ) { context, size in
            context.opacity = 0.3

            let text = Text(verbatim: "Hello").font(.largeTitle)
            var resolvedText = context.resolve(text)
            resolvedText.shading = .color(.black)
            context.draw(resolvedText, in: .init(origin: .zero, size: size))
//            context.draw(resolvedText, in: size)
        }
    }

    private var circles: some View {
        Canvas(
            opaque: true,
            colorMode: .linear,
            rendersAsynchronously: false
        ) { context, size in
            context.opacity = 1

            let rect = CGRect(origin: .zero, size: size)

            var path = Circle().path(in: rect)
            context.fill(path, with: .color(.green))

            let newRect = rect.applying(.init(scaleX: 0.5, y: 0.5))
            path = Circle().path(in: newRect)
            context.fill(path, with: .color(.red))
        }
        .frame(width: 200, height: 200)
    }

    private var shapedText: some View {
        Text("Hello")
            .font(.largeTitle)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
            )
    }
}



#Preview {
    Test()
    .padding()
//    .frame(width: 200, height: 200)
}
