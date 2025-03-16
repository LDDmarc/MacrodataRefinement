//
//  NumbersView.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 01.03.2025.
//

import SwiftUI

extension NumbersView {
    enum Constants {
        static let cellSize: CGFloat = 84
    }
}

struct NumbersView: View {

    @State
    private var viewModel = NumbersViewModel(file: .init(
        id: "1",
        name: "Cold harbour",
        bins: (1...5).map { MacrodataBin(
            id: $0,
            allNumbersCount: Int.random(in: 20...100),
            currentNumbersCount: 0
        ) }
    ))

    @Namespace
    private var moveToBoxAnimation


    var body: some View {
        VStack(spacing: 4) {
            header

            dividers
            grid
            dividers
            boxes
        }
        .background(Color.darkBlue)
        /// older machine look
        .overlay {
            GrainOverlay()
                .allowsHitTesting(false)
        }
        .blur(radius: 0.5)
    }

    private var headerBorder: some View {
        VStack(alignment: .leading, spacing: 0) {
            divider
                .padding(.trailing, 26)

            HStack {
                Rectangle()
                    .fill(Color.lightBlue)
                    .frame(width: 2)
                Spacer()
                LumonLogo()
                    .frame(width: 140, height: 70)
            }
            .frame(height: 50)

            divider
                .padding(.trailing, 26)
        }

    }

    private var header: some View {
        ZStack {
            headerBorder
            HStack {
                Text(viewModel.title)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(Color.lightBlue)
                    .lineLimit(1)
                Spacer()
                (Text(viewModel.fileProgress, format: .percent.precision(.significantDigits(1))) + Text(" Complete"))
                    .stroke(color: .lightBlue, width: 1)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(Color.darkBlue)
                    .lineLimit(1)

                Spacer()
                    .frame(width: 140, height: 70)
            }
            .padding(.horizontal)
        }
        .padding(20)
        .padding(.leading, 20)
    }

    private var dividers: some View {
        VStack(spacing: 2) {
            divider
            divider
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.lightBlue)
            .frame(height: 2)
    }

    private var boxes: some View {
        VStack {
            HStack(spacing: 50) {
                ForEach(viewModel.boxViewModels) { boxViewModel in
                    box(boxViewModel: boxViewModel)
                }
            }
            HStack(spacing: 50) {
                ForEach(Array(viewModel.boxProgresses.enumerated()), id: \.offset) { _, progress in
                    BoxProgressView(progress: progress)
                        .frame(height: 30)
                }
            }
        }
        .padding(.bottom)
        .padding(.horizontal, 40)
        .background(Color.darkBlue)
        .padding(.horizontal)
    }

    @ViewBuilder
    private func box(boxViewModel: MysteriousBoxViewModel) -> some View {
        ZStack(alignment: .center) {
            if boxViewModel.isMoveToBox {
                selectedNumbers
            }
            MysteriousBoxView(viewModel: boxViewModel)
                .onTapGesture {
                    viewModel.onBoxTap(boxViewModel: boxViewModel)
                }
        }
    }

    private func dragGesture(in proxy: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in                viewModel.onDrag(in: value.location)
            }
            .onEnded { _ in
                viewModel.onDragEnded()
            }
    }

    private var grid: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: viewModel.updateColumnsIn(size: proxy.size), spacing: 0) {
                    ForEach(viewModel.numbers) { numberViewModel in
                        if viewModel.isMovingToBox, numberViewModel.isSelected {
                            Rectangle()
                                .fill(.clear)
                                .frame(width: Constants.cellSize, height: Constants.cellSize)
                        } else {
                            numberView(viewModel: numberViewModel)
                                .frame(width: Constants.cellSize, height: Constants.cellSize)
                        }
                    }
                }
                .onContinuousHover(perform: { phase in
                    switch phase {
                    case .active(let location):
                        viewModel.onHover(in: location)
                    case .ended:
                        viewModel.onStopHoveringNumbers()
                    }
                })
                .gesture(
                    dragGesture(in: proxy)
                )
                .onTapGesture { location in
                    viewModel.onTap(in: location)
                }
                .onGeometryChange(for: CGRect.self) { proxy in
                    proxy.frame(in: .global)
                } action: { newValue in
                    viewModel.onSizeChange(newValue.size)
                }
            }
        }
    }

    private var selectedNumbers: some View {
        ForEach(viewModel.numbers.filter(\.isSelected)) {
            numberView(viewModel: $0)
                .frame(width: 1, height: 1)
        }
    }

    private func numberView(viewModel: NumberViewModel) -> some View {
        NumberView(viewModel: viewModel)
            .foregroundColor(Color.lightBlue)
            .environment(\.namespace, moveToBoxAnimation)
            .matchedGeometryEffect(id: viewModel.id.uuidString, in: moveToBoxAnimation)
    }
}

#Preview {
    NumbersView()
        .frame(width: 500, height: 500)
}
