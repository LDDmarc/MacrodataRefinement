//
//  FoldersView.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 16.03.2025.
//

import SwiftUI

struct FoldersView: View {

    @State var viewModel = FoldersViewModel()

    private let offset: CGFloat = 0
    private let folderHeight: CGFloat = 120

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                wheel
                folders
                wheel
            }
            Spacer(minLength: 200)

            Button("Animate") {
                viewModel.flip()
            }
        }
        .padding(50)
        .background(Color.darkBlue)
    }

    private var wheel: some View {
        WheelView(viewModel: viewModel.wheelViewModel)
            .frame(width: 15, height: 50)
    }

    private var folders: some View {
        ZStack {
            VStack(spacing: 0) {
                dummyFolders // top

                if viewModel.bottomFolders.isEmpty {
                    dummyFolders
                } else {
                    bottomFolders
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 0, z: 1))
                }
            }
            staplers
            .frame(height: 0.1 * folderHeight)

            VStack(spacing: 0) {
                topFolders
                dummyFolders // bottom
            }

        }
    }

    private var staplers: some View {
        let part = UnevenRoundedRectangle(cornerRadii: .init(
            topLeading: 4, topTrailing: 4
        ))
            .fill(Color.lightBlue)
            .frame(width: 8)
        return HStack(spacing: 90) {
            part
            part
        }
    }

    private var dummyFolders: some View {
        Spacer().frame(height: folderHeight)
    }

    private var topFolders: some View {
        ZStack {
            ForEach(Array(
                viewModel
                    .topFolders
                    .reversed().enumerated()
            ), id: \.offset) { ind, _folder in
                let index = viewModel.topFolders.count - 1 - ind
                let isBackwards = index > 1

                return folder(_folder)
                    .rotation3DEffect(
                        .degrees(isBackwards ? 10 * Double(index) : -10 * Double(index)),
                        axis: (x: 1, y: 0, z: 0),
                        anchor: .bottom,
                        perspective: isBackwards ? 1 : 0.1
                    )
            }
        }
    }


//    private var topFolders: some View {
//        ZStack {
//            ForEach(Array(
//                viewModel
//                    .topFolders
//                    .reversed().enumerated()
//            ), id: \.offset) { ind, _folder in
//                if _folder.isVisible {
//                    folder(_folder)
//                        .rotation3DEffect(
//                            .degrees(_folder.isFlipping ?  -180.0 : 0),
//                            axis: (x: 1, y: 0, z: 0),
//                            anchor: .bottom,
//                            perspective: 0.1
//                        )
//                        .transition(.offset(y: 40))
//                }
//            }
//        }
//    }

    private var bottomFolders: some View {
        ZStack {
            ForEach(Array(viewModel.bottomFolders.reversed().enumerated()), id: \.offset) { ind, _folder in
//                if _folder.isVisible {
//                    folder(_folder)                        .transition(.offset(y: offset))
//                }
                folder(_folder)
//                    .rotation3DEffect(
//                        .degrees(-2 * Double(viewModel.bottomFolders.count - 1 - ind)),
//                        axis: (x: 1, y: 0, z: 0),
//                        anchor: .bottom,
//                        perspective: 0.1
//                    )
            }
        }
    }

    private func folderLetter(_ folder: Folder, shift: Double) -> some View {
        let _shift =  Spacer().frame(width: shift)
        return HStack(spacing: 0) {
            if !folder.isFlipped { _shift }
            Text(folder.letter?.letter ?? " ")
                .foregroundColor(.darkBlue)
                .font(.title2)
                .opacity(folder.isTextVisible ? 1 : 0)
                .padding(.top, 0)
                .padding(.bottom, 2)
                .padding(.horizontal, 16)
                .background(
                    RoundedTrapezoid()
                        .fill(folder.isTextVisible ? Color.lightBlue : Color.darkBlue)
                        .stroke(Color.lightBlue, lineWidth: 2)
                )
            if folder.isFlipped { _shift }
        }
        .opacity(folder.letter != nil ? 1 : 0)
    }

    private func folder(_ folder: Folder) -> some View {
        VStack(spacing: -0.15 * folderHeight) {
            ZStack {
                VStack(alignment: !folder.isFlipped ? .leading : .trailing, spacing: -1.0) {
                    folderLetter(folder, shift: 10 * Double(folder.letter?.index ?? 0))
                        .zIndex(1)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.darkBlue)
                        .stroke(Color.lightBlue, lineWidth: 2.0)
                }
                .frame(height: 0.93 * folderHeight)

                Text(folder.name)
                    .foregroundColor(.lightBlue)
                    .opacity(folder.isTextVisible ? 1 : 0)
            }

            staplers
        }
        .frame(width: 150, height: folderHeight)
        .offset(y: folder.isOnTop ? 0 : -offset)
    }

}

#Preview {
    FoldersView()
//        .scaleEffect(2.99)
        .frame(width: 400, height: 500)
}
