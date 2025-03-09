//
//  NumbersViewModel.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 01.03.2025.
//

import SwiftUI

@Observable
final class NumbersViewModel {

    private typealias Constants = NumbersView.Constants

    // MARK: - Internal Properties

    var numbers: [NumberViewModel] = (1...300).map { _ in NumberViewModel(number: Int.random(in: 0...9)) }
    var boxViewModels: [MysteriousBoxViewModel]
    var boxProgresses: [Double] {
        file.bins.map(\.progress)
    }
    var fileProgress: Double {
        file.progress
    }
    var title: String {
        file.name
    }
    var columns = Array(repeating: GridItem(.fixed(Constants.cellSize), spacing: 0), count: 5)

    var isMovingToBox: Bool {
        boxViewModels.contains(where: \.isMoveToBox)
    }

    // MARK: - Private Properties

    private var isHovering = true
    private var needToDeselect = false

    private var file: MacrodataFile

    // MARK: - Init

    init(file: MacrodataFile) {
        self.file = file
        self.boxViewModels = file.bins.map { MysteriousBoxViewModel(id: $0.id) }
    }

    // MARK: - Internal Methods

    func onTap(in location: CGPoint) {
        isHovering = true
        deselectAll()
        updateSelection(in: location, state: .hovered)
    }

    func onDrag(in location: CGPoint) {
        if needToDeselect {
            deselectAll()
            needToDeselect = false
        }
        isHovering = false
        updateSelection(in: location, state: .selected)
    }

    func onDragEnded() {
        needToDeselect = true
    }

    func onHover(in location: CGPoint) {
        if isHovering {
            deselectAll()
            updateSelection(in: location, state: .hovered)
        }
    }

    func onStopHoveringNumbers() {
        if numbers.filter(\.isSelected).isEmpty {
            deselectAll()
        }
    }

    func onBoxTap(boxViewModel: MysteriousBoxViewModel) {
        guard numbers.filter(\.isSelected).count > 0 else { return }
        guard let index = boxViewModels.firstIndex(where: { $0.id == boxViewModel.id }) else { return }

        withAnimation(.easeInOut(duration: 0.6)) {
            boxViewModels[index].open()
        } completion: { [weak self] in
            withAnimation(.linear(duration: 1)) {
                self?.boxViewModels[index].isMoveToBox = true
            } completion: { [weak self] in
                self?.numbers.forEach { $0.isAnimating = false }

                withAnimation(.easeInOut(duration: 0.6)) {
                    self?.boxViewModels[index].close()
                } completion: {
                    self?.onMoveToBoxFinished(index: index)
                }
            }
        }

    }

    func onSizeChange(_ size: CGSize) {
        columns = makeColumns(size)
    }

    // HACK: to keep logic in model, but to update model.columns only when size changed (not by view request)
    func updateColumnsIn(size: CGSize) -> [GridItem] {
        makeColumns(size)
    }


}

// MARK: - Private Methods

private extension NumbersViewModel {

    func makeColumns(_ size: CGSize) -> [GridItem] {
        let columnsNumber = max(1, Int(size.width / Constants.cellSize))
        return Array(repeating: GridItem(.fixed(Constants.cellSize), spacing: 0), count: columnsNumber)
    }

    func onMoveToBoxFinished(index: Int) {
        let selectedNumbersCount = numbers.filter(\.isSelected).count
        let newNumbers = (1...selectedNumbersCount).map { _ in NumberViewModel(number: Int.random(in: 0...9)) }
        newNumbers.forEach { $0.isAnimating = false }
        let indices = numbers.indices.filter { numbers[$0].isSelected }

        deselectAll()
        numbers.removeAll(where: \.isSelected)

        withAnimation(.bouncy(duration: 0.5)) {
            for i in 0..<indices.count {
                numbers[indices[i]] = newNumbers[i]
            }
            isHovering = true
            boxViewModels[index].isMoveToBox = false

            file.bins[index].addNumbers(selectedNumbersCount)
        } completion: { [weak self] in
            self?.numbers.forEach { $0.isAnimating = true }
            self?.numbers.forEach {  $0.animateFloating() }
        }
    }

    func updateSelection(in location: CGPoint, state: NumberViewModel.State) {
        let column = Int(location.x / Constants.cellSize)
        let row = Int(location.y / Constants.cellSize)
        let index = row * columns.count + column

        withAnimation {
            for i in (row - 1)...(row + 1) {
                for j in (column - 1)...(column + 1) {
                    let ind = i * columns.count + j
                    numbers[safe: ind]?.set(state: .neighbour)
                }
            }
            numbers[safe: index]?.set(state: state)
        }
    }

    func deselectAll() {
        withAnimation {
            for ind in 0..<numbers.count {
                numbers[safe: ind]?.set(state: .none)
            }
        }
    }

}

