//
//  FoldersView.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 16.03.2025.
//

import SwiftUI

struct Folder: Identifiable {
    let id = UUID()
    let name: String
    var isAnimating = false
    var isOnTop = false
    var isTextVisible = true
}

@Observable
final class FoldersViewModel {
    var topFolders = ["Lorem", "Ipsum", "Dragon", "Consectetur"].map { Folder(name: $0) }
    var bottomFolders = [""].map { Folder(name: $0) }

    private let animationDuration: TimeInterval = 1

    init() {
        topFolders[0].isOnTop = true
        bottomFolders[safe: 0]?.isOnTop = true
    }

    func flip() {
        guard !topFolders.isEmpty else { return }
        
        withAnimation(.linear(duration: animationDuration)) {
            topFolders[safe: 1]?.isOnTop = true
            bottomFolders[safe: 0]?.isOnTop = false
            topFolders[0].isAnimating = true
        } completion: { [weak self] in
            guard let self else {
                return
            }
            bottomFolders.insert(topFolders[0], at: 0)
            topFolders.remove(at: 0)

            flip()
        }
        withAnimation(.linear(duration: animationDuration / 2)) {
            topFolders[0].isTextVisible = false
        }

    }

}

struct FoldersView: View {

    @State var viewModel = FoldersViewModel()

    private let offset: CGFloat = 10
    private let distance: CGFloat = 20
    private let folderHeight: CGFloat = 100

    var body: some View {
        
        VStack(spacing: 0) {

            test


            Spacer(minLength: 200)

            Button("Animate") {
                viewModel.flip()
            }
        }
        .padding(50)
        .background(Color.darkBlue)
    }

    private var test: some View {
        ZStack {
            VStack(spacing: 0) {
                dummyFolders // top

                dummyStaplers

                if viewModel.bottomFolders.isEmpty {
                    dummyFolders
                } else {
                    bottomFolders
                }
            }

            VStack(spacing: 0) {
                topFolders

                dummyStaplers
                dummyFolders // bottom
            }

            staplers
        }
    }

    private var staplers: some View {
        HStack(spacing: 100) {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.lightBlue)
                .frame(width: 8, height: distance * 2)


            RoundedRectangle(cornerRadius: 5)
                .fill(Color.lightBlue)
                .frame(width: 8, height: distance * 2)
        }
    }

    private var dummyStaplers: some View {
        Spacer()
            .frame(height: distance)
    }

    private var dummyFolders: some View {
        Spacer()
            .frame(height: folderHeight)
    }


    private var topFolders: some View {
        ZStack {
            ForEach(Array(viewModel.topFolders.reversed().enumerated()), id: \.offset) { ind, _folder in
                let angle: Double = _folder.isAnimating ?  -180.0 : 0
                folder(_folder)
                    .offset(y: _folder.isOnTop ? 0 : -offset)
                    .rotation3DEffect(
                        .degrees(angle),
                        axis: (x: 1, y: 0, z: 0),
                        anchor: .bottom,
                        perspective: 0.1
                    )
                    .offset(y: _folder.isAnimating ? distance : 0)
            }
        }
    }

//    private var topFolders: some View {
//        ZStack {
//            ForEach(Array(viewModel.topFolders.enumerated()), id: \.offset) { ind, name in
//
//                let offSet: Double = isAnimating ? 50 : 0
//                let angle: Double = isAnimating ? -180 : 0
//                let animation = Animation.linear(duration: 1).delay(
//                    TimeInterval(viewModel.topFolders.count - 1 - ind) * animationDuration
//                )
//                let zIndex = isAnimating ? Double(viewModel.topFolders.count - 1 - ind) : Double(ind)
//
//                folder(name: name.name, fillColor: colors[ind])
//                    .offset(y: CGFloat(ind) * 10)
//                    .rotation3DEffect(
//                        .degrees(angle),
//                        axis: (x: 1, y: 0, z: 0),
//                        anchor: .bottom,
//                        perspective: 0.1
//                    )
//                    .offset(y: offSet)
//                    .animation(animation, value: angle)
//                    .animation(animation, value: offSet)
//                    .animation(animation, value: zIndex)
//
//            }
//        }
//    }

    private var bottomFolders: some View {
        ZStack {
            ForEach(Array(viewModel.bottomFolders.reversed().enumerated()), id: \.offset) { ind, _folder in
                folder(_folder, fillColor: .green)
                    .offset(y: _folder.isOnTop ? 0 : offset)
            }
        }
    }


    private func folder(_ folder: Folder, fillColor: Color = .red) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.darkBlue)
                .stroke(Color.lightBlue, lineWidth: 3)
            Text(folder.name)
                .foregroundColor(.lightBlue)
                .opacity(folder.isTextVisible ? 1 : 0)
        }
        .frame(width: 150, height: folderHeight)
    }
}

#Preview {
    FoldersView()
        .frame(height: 600)
}
