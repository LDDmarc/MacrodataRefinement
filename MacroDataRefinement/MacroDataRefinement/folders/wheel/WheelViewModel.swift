//
//  WheelViewModel.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 18.03.2025.
//

import SwiftUI

struct WheelRectangle: Identifiable {
    let id = UUID()
    var point: CGPoint
}

@Observable
final class WheelViewModel {

    var rectangles = [WheelRectangle]()
    var rectangleSize = CGSize.zero

    private var size: CGSize = .zero
    private let totalRectanglesNumber = 12

    func move() {
        let tmp = rectangles[0].point
        for i in 1..<rectangles.count {
            rectangles[i - 1].point = rectangles[i].point
        }

        rectangles.removeLast()
        rectangles.insert(.init(point: tmp), at: 0)
    }

    func onSizeChange(_ size: CGSize) {
        self.size = size
        rectangleSize = CGSize(
            width: size.width, height: size.height * 0.054
        )
        makeRectangles(in: size)
    }


}

// MARK: - Private Methods

private extension WheelViewModel {

    func makeRectangles(in rect: CGSize) {
        rectangles.removeAll()
        let deltas = getDeltas(in: size.height, points: totalRectanglesNumber)
        for i in 0..<totalRectanglesNumber {
            rectangles.append(.init(point: .init(
                x: rect.width / 2,
                y: (rectangles[safe: i - 1]?.point.y ?? 0) + (deltas[safe: i] ?? 0)
            )))
        }
    }

    func getDeltas(in length: Double, points n: Int) -> [Double] {
        guard n >= 2 else {
            return [length]
        }

        let segments = n - 1
        let m = segments / 2
        var deltas = [Double]()


        if segments % 2 == 0 {
            let factor = length / Double(m * (m + 1))
            // Compute increasing differences: d1, d2, ... dm
            let firstHalf = (1...m).map { Double($0) * factor }
            // Full sequence: increasing differences and then the mirror (decreasing)
            deltas = firstHalf + firstHalf.reversed()
        } else {
            // Odd number of segments
            let factor = length / Double((m + 1) * (m + 1))
            // Increasing differences: d1, d2, ... d(m+1)
            let increasing = (1...m+1).map { Double($0) * factor }
            // Full sequence: increasing then decreasing (without repeating the middle element)
            deltas = increasing + increasing.dropLast().reversed()
        }

        return deltas
    }

}
