//
//  MysteriousBoxViewModel.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 05.03.2025.
//

import SwiftUI

@Observable
final class MysteriousBoxViewModel: Identifiable {

    // MARK: - Internal Properties

    var openProgress: CGFloat {
        isOpen ? 1 : 0
    }

    let id: Int
    var isMoveToBox = false

    var number: String {
        String(format: "%02d", id)
    }

    // MARK: - Private Properties

    private var isOpen = false

    // MARK: - Init

    init(id: Int) {
        self.id = id
    }

    // MARK: - Internal Methods

    func open() {
        isOpen = true
    }

    func close() {
        isOpen = false
    }
    
}
