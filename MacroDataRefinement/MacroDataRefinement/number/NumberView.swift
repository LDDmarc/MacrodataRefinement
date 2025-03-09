//
//  NumberView.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 01.03.2025.
//

import SwiftUI

struct NumberView: View {
    @Environment(\.namespace) var namespace
    var viewModel: NumberViewModel

    var body: some View {
        GeometryReader { proxy in
            Text(viewModel.number, format: .number)
                .font(viewModel.font)
                .scaleEffect(viewModel.scale)
                .position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
                .offset(viewModel.offset)
                .onGeometryChange(for: CGRect.self) { proxy in
                    proxy.frame(in: .global)
                } action: { newValue in
                    viewModel.onSizeChange(newValue.size)
                }
                .onAppear {
                    viewModel.onAppear()
                }
                .onDisappear {
                    viewModel.onDisappear()
                }
        }
    }

}

#Preview {
    NumberView(viewModel: .init(number: 1))
        .frame(width: 100, height: 100)
}
