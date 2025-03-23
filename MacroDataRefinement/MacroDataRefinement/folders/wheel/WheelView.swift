//
//  WheelView.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 16.03.2025.
//

import SwiftUI

struct WheelView: View {
    var viewModel = WheelViewModel()

    var body: some View {
        ZStack {
            ForEach(viewModel.rectangles) { rect in
                Rectangle()
                    .fill(Color.lightBlue)
                    .frame(
                        width: viewModel.rectangleSize.width,
                        height: viewModel.rectangleSize.height
                    )
                    .position(rect.point)
            }
        }
        .onGeometryChange(for: CGRect.self) { proxy in
            proxy.frame(in: .global)
        } action: { newValue in
            viewModel.onSizeChange(newValue.size)
        }
    }
}

#Preview {
    WheelView()
        .frame(width: 100, height: 300)
        .padding()
}
