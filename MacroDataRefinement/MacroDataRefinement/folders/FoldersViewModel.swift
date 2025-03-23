//
//  FoldersViewModel.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 18.03.2025.
//

import SwiftUI

struct Folder: Identifiable {
    enum State: Equatable {
        case faced(Position), flipping, flipped(Position)

        enum Position {
            case onTop
            case second
            case hidden
        }
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
        switch state {
        case .faced(let position), .flipped(let position): position != .hidden
        case .flipping: true
        }
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
        case .faced(let position), .flipped(let position): position == .onTop
        case .flipping: true
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
        case .faced:
            state = .faced(.onTop)
        default:
            break
        }
    }

    mutating func moveToBottom() {
        switch state {
        case .flipped:
            state = .flipped(.second)
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

    private let animationDuration: TimeInterval = 0.4

    init() {
        fillFolders()
    }

    func flip() {
        guard topFolders[0].name != "Cold Harbor" else { return }

        withAnimation(.easeIn(duration: animationDuration)) {
            topFolders[safe: 1]?.moveToTop()
            topFolders[safe: 2]?.state = .faced(.second)
            bottomFolders[safe: 0]?.moveToBottom()
            bottomFolders[safe: 1]?.state = .flipped(.hidden)
            topFolders[safe: 0]?.state = .flipping
            wheelViewModel.move()
            
        } completion: { [weak self] in
            guard let self else {
                return
            }
            var flippedFolder = topFolders[0]
            flippedFolder.state = .flipped(.onTop)
            bottomFolders.insert(flippedFolder, at: 0)
            topFolders.remove(at: 0)

            flip()
        }

        withAnimation(.linear(duration: animationDuration / 2).delay(animationDuration / 3)) {
            topFolders[safe: 0]?.isTextVisible = false
        }
    }

}

// MARK: - Private Methods

private extension FoldersViewModel {

    func fillFolders() {
        var firstLetter: String?
        var letterIndex = -1
        topFolders = [
            "Adelaide",
            "Allentown",
            "Astoria",
            "Billings",
            "Boda",
            "Cairnes",
            "Cold Harbor",
            "Dranesville",
            "Eau Claire",
            "Eminence",
            "Erie",
            "Fort Dodge",
            "Gold Coast",
        ]
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
                        state: .faced(.hidden),
                        letter: .init(letter: firstLetter ?? "", index: letterIndex),
                        isTextVisible: true
                    ))
                }
                partialResult.append(Folder(
                    name: room,
                    state: .faced(.hidden),
                    letter: nil,
                    isTextVisible: true
                ))
            })
        topFolders[safe: 0]?.state = .faced(.onTop)
        for ind in 1..<2 {
            topFolders[safe: ind]?.state = .faced(.second)
        }

        bottomFolders.append(Folder(name: "", state: .flipped(.onTop), letter: nil, isTextVisible: false))
    }

}
