//
//  FoldersViewModel.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 18.03.2025.
//

import SwiftUI

struct Folder: Identifiable {
    enum State: Equatable {
        case hidden, presented(isOnTop: Bool), flipping, flipped(isOnTop: Bool)
    }

    struct Letter {
        let letter: String
        let index: Int
    }

    let id = UUID()

    let name: String
    var state: State
    let letter: Letter?
    var isTextVisible: Bool
    var isVisible: Bool {
        state != .hidden
    }

    var isFlipping: Bool {
        state == .flipping
    }
    var isFlipped: Bool {
        switch state {
        case .flipped: true
        default: false
        }
    }
    var isOnTop: Bool {
        switch state {
        case .presented(let isOnTop), .flipped(let isOnTop):
            return isOnTop
        case .flipping:
            return true
        case .hidden:
            return false
        }
    }

    init(name: String, state: State, letter: Letter?, isTextVisible: Bool) {
        self.name = name
        self.state = state
        self.letter = letter
        self.isTextVisible = isTextVisible
    }

    mutating func moveToTop() {
        switch state {
        case .presented:
            state = .presented(isOnTop: true)
        default:
            break
        }
    }

    mutating func moveToBottom() {
        switch state {
        case .flipped:
            state = .flipped(isOnTop: false)
        default:
            break
        }
    }

}

@Observable
final class FoldersViewModel {
    private(set) var topFolders = [Folder]()
    private(set) var bottomFolders = [Folder]()
    let wheelViewModel = WheelViewModel()

    private let animationDuration: TimeInterval = 1.4

    init() {
        fillFolders()
    }

    func flip() {
        guard topFolders.count > 1 else { return }

        withAnimation(.easeIn(duration: animationDuration)) {
            topFolders[safe: 1]?.moveToTop()
            topFolders[safe: 2]?.state = .presented(isOnTop: false)
            bottomFolders[safe: 0]?.moveToBottom()
            bottomFolders[safe: 1]?.state = .hidden
            topFolders[safe: 0]?.state = .flipping
            wheelViewModel.move()
            
        } completion: { [weak self] in
            guard let self else {
                return
            }
            var flippedFolder = topFolders[0]
            flippedFolder.state = .flipped(isOnTop: true)
            bottomFolders.insert(flippedFolder, at: 0)
            topFolders.remove(at: 0)

            flip()
        }

        withAnimation(.linear(duration: animationDuration / 2)) {
            topFolders[safe: 0]?.isTextVisible = false
        }
    }

}

// MARK: - Private Methods

private extension FoldersViewModel {

    func fillFolders() {
        var firstLetter: String?
        var letterIndex = -1
        topFolders = ["Lorem", "Dragon", "Consectetur", "Afina", "Delta", "Cold Harbour", "Wellington", "Barman", "Frida", "Abracadabra", "America", "Linda"]
            .sorted()
            .reduce(into: [Folder](), { partialResult, room in
                if
                    let letter = room.first,
                    String(letter) != firstLetter
                {
                    firstLetter = String(letter)
                    letterIndex += 1
                    partialResult.append(Folder(
                        name: "",
                        state: .hidden,
                        letter: .init(letter: firstLetter ?? "", index: letterIndex),
                        isTextVisible: true
                    ))
                }
                partialResult.append(Folder(
                    name: room,
                    state: .hidden,
                    letter: nil,
                    isTextVisible: true
                ))
            })
        topFolders[safe: 0]?.state = .presented(isOnTop: true)
        for ind in 1..<2 {
            topFolders[safe: ind]?.state = .presented(isOnTop: false)
        }

        bottomFolders.append(Folder(name: "", state: .flipped(isOnTop: true), letter: nil, isTextVisible: false))
    }

}
