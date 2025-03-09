//
//  Array+.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 01.03.2025.
//

import Foundation

extension MutableCollection {
    /// Returns the element at the specified index iff it is within count, otherwise nil.
    subscript (safe index: Index) -> Element? {
        get {
            indices.contains(index) ? self[index] : nil
        }
        mutating set {
            if indices.contains(index), let value = newValue {
                self[index] = value
            }
        }
    }
}
