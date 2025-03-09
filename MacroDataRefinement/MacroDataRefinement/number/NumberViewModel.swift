//
//  NumberViewModel.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 01.03.2025.
//

import SwiftUI

@Observable
final class NumberViewModel: Identifiable {

    let number: Int
    let id = UUID()

    var font: Font {
        .system(size: 20, weight: .bold, design: .default)
    }
    var scale: CGFloat {
        switch state {
        case .selected, .hovered: 2.43
        case .neighbour: 1.57
        case .none: 1.0
        }
    }
    var isSelected: Bool {
        state == .selected
    }

    private(set) var offset = CGSize.zero
    private var state = State.none
    private let isHorizontal = Bool.random()

    var isAnimating = true

    private var viewSize: CGSize = .zero
    private var isVisible = false

    init(number: Int) {
        self.number = number
    }

    func set(state: State) {
        switch self.state {
        case .selected where state == .neighbour:
            break
        default:
            self.state = state
        }
    }

    func onAppear() {
        isVisible = true
        animateFloating()
    }

    func onDisappear() {
        isVisible = false
    }

    func onSizeChange(_ size: CGSize) {
        viewSize = size
    }

    func animateFloating() {
        guard isAnimating && isVisible else { return }
        withAnimation(.linear(duration: 2.0)) {
            offset = randomizeOffset(in: viewSize)
        } completion: { [weak self] in
            self?.animateFloating()
        }
    }

    private func randomizeOffset(in size: CGSize) -> CGSize {
        let maxOffset = size.width / 6
        let offset = CGFloat.random(in: -maxOffset...maxOffset)
        if isHorizontal {
            return CGSize(width: offset, height: 0)
        } else {
            return CGSize(width: 0, height: offset)
        }
    }


}

// MARK: - Nested Types

extension NumberViewModel {
    enum State {
        case selected
        case hovered
        case neighbour
        case none
    }
}
