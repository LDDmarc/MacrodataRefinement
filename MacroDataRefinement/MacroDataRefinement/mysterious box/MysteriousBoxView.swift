//
//  MysteriousBoxView.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 05.03.2025.
//

import SwiftUI

struct MysteriousBoxView: View {

    var viewModel: MysteriousBoxViewModel
    let lineWidth: CGFloat = 2

    var body: some View {
        ZStack {
            FilledBoxShape(openProgress: viewModel.openProgress)
                .fill(Color.darkBlue)

            BoxShape(openProgress: viewModel.openProgress)
                .stroke(Color.lightBlue, lineWidth: lineWidth)

            Text(viewModel.number)
                .foregroundStyle(Color.lightBlue)
                .font(.system(size: 20, weight: .bold, design: .default))
        }
        .aspectRatio(3.99, contentMode: .fit)
        .padding(lineWidth / 2)
    }

}

#Preview {
    @Previewable @State
    var viewModel = MysteriousBoxViewModel(id: 1)

    MysteriousBoxView(viewModel: viewModel)
        .padding(.horizontal, 150)
        .onTapGesture {
            withAnimation {
                viewModel.open()
            } completion: {
                withAnimation(.default.delay(1)) {
                    viewModel.close()
                }
            }
        }
}
