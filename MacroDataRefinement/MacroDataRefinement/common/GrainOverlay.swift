//
//  Granular.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 09.03.2025.
//

import SwiftUI

struct GrainOverlay: View {
    var body: some View {
        Canvas { context, size in
            let gridSpacing: CGFloat = size.width / 300
            // Loop over x and y coordinates in a fixed grid pattern
            for x in stride(from: 0, through: size.width, by: gridSpacing) {
                for y in stride(from: 0, through: size.height, by: gridSpacing) {
                    let rect = CGRect(x: x, y: y, width: 0.5, height: 0.5)
                    context.fill(Path(rect), with: .color(.white.opacity(0.5)))
                }
            }

//            for _ in 0..<200 {
//                let x = CGFloat.random(in: 0...size.width)
//                let y = CGFloat.random(in: 0...size.height)
//                let rect = CGRect(x: x, y: y, width: 1.5, height: 1.5)
//                context.fill(Path(rect), with: .color(.white))
//            }
        }
        .blendMode(.luminosity)
        .ignoresSafeArea()
    }
}
