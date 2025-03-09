//
//  BoxProgressView.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 08.03.2025.
//

import SwiftUI

struct BoxProgressView: View {

    var progress: Double = 0.0

    var body: some View {
        GeometryReader { proxy in
            let totalWidth = proxy.size.width
            let filledWidth = totalWidth * CGFloat(progress)

            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.darkBlue)
                    .stroke(Color.lightBlue, lineWidth: 2)
                Rectangle()
                    .fill(Color.lightBlue)
                    .frame(width: filledWidth)

                Text(progress, format: .percent.precision(.significantDigits(1)))
                    .stroke(color: .lightBlue, width: 1)
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundStyle(Color.darkBlue)
                    .padding(.leading)
            }
        }
    }
}

#Preview {
    BoxProgressView(progress: 0.02)
        .frame(width: 300, height: 50)
        .padding()

}
