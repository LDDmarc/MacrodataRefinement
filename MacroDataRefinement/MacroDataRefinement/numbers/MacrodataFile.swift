//
//  MacrodataFile.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 09.03.2025.
//

import Foundation

struct MacrodataFile: Identifiable {
    let id: String
    let name: String
    var bins: [MacrodataBin]
    var progress: Double { bins.reduce(0) { $0 + $1.progress } / Double(bins.count) }
}

struct MacrodataBin: Identifiable {
    let id: Int
    var progress: Double { Double(currentNumbersCount) / Double(allNumbersCount) }

    private let allNumbersCount: Int
    private var currentNumbersCount: Int

    init(id: Int, allNumbersCount: Int, currentNumbersCount: Int) {
        self.id = id
        self.allNumbersCount = allNumbersCount
        self.currentNumbersCount = currentNumbersCount
    }

    mutating func addNumbers(_ count: Int) {
        currentNumbersCount += count
    }
}
