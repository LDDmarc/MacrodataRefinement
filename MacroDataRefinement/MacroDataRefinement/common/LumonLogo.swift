//
//  LumonLogo.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 08.03.2025.
//

import SwiftUI

/// Suitable ascpect ratio is 0.5
struct LumonLogo: View {
    let lineWidth: CGFloat

    init(lineWidth: CGFloat = 2) {
        self.lineWidth = lineWidth
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ellipse
                    .frame(width: 0.34 * proxy.size.width)

                ellipse
                    .frame(width: 0.7 * proxy.size.width)

                ellipse

                Image("LOGO")
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical, 0.07 * proxy.size.height)
                    .frame(width: 0.76 * proxy.size.width)
                    .foregroundStyle(Color.lightBlue)
                    .background(Color.darkBlue)
            }
        }
    }

    private var ellipse: some View {
        Ellipse()
            .stroke(Color.lightBlue, lineWidth: lineWidth)
            .fill(.clear)
    }
}

#Preview {
    LumonLogo()
        .frame(width: 283, height: 140)
        .padding()
        .background(Color.darkBlue)

}
