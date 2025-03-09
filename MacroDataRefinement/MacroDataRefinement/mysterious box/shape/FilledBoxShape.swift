//
//  FilledBoxShape.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 06.03.2025.
//

import SwiftUI

/// Workaround for SwiftUI animation bug

struct FilledBoxShape: Shape {

    /// Progress of the box opening. 0.0 is closed, 1.0 is open.
    var openProgress: CGFloat = 0.0

    var animatableData: CGFloat {
        get { openProgress }
        set { openProgress = newValue }
    }

    typealias Constants = BoxShape.Constants

    func path(in rect: CGRect) -> Path {
        let boxWidth = rect.width * Constants.boxWidthRatio
        let boxHeight = boxWidth * Constants.aspectRatio
        let boxSize = CGSize(width: boxWidth, height: boxHeight)
        let shadowOffset = boxHeight * Constants.shadowRatio

        let start = CGPoint(
            x: Int((rect.width - boxSize.width) / 2),
            y: Int(rect.height)
        )

        // box
        let boxLeftBot = CGPoint(x: start.x, y: start.y)
        let boxLeftTop = CGPoint(x: start.x, y: start.y - boxSize.height)
        let boxRightBot = CGPoint(x: start.x + boxSize.width, y: start.y)
        let boxRightTop = CGPoint(x: start.x + boxSize.width, y: start.y - boxSize.height)

        let radians = CGFloat(openProgress) * Constants.lidRadians

        let boxLidLeftTop = CGPoint(
            x: boxLeftTop.x + boxSize.width / 2.0 * cos(-radians),
            y: boxLeftTop.y + boxSize.width / 2.0 * sin(-radians)
        )

        let boxLidRightTop = CGPoint(
            x: boxRightTop.x - boxSize.width / 2.0 * cos(radians),
            y: boxRightTop.y - boxSize.width / 2.0 * sin(radians)
        )

        let offset = CGFloat(shadowOffset * openProgress)

        let shadowLeftTop: CGPoint
        let shadowRightTop: CGPoint
        let shadowLidLeftTop: CGPoint
        let shadowLidRightTop: CGPoint

        // top
        if radians < CGFloat.pi / 2.0 {
            shadowRightTop = CGPoint(
                x: boxRightTop.x - offset * _math.cos(radians),
                y: boxRightTop.y - offset * _math.sin(radians)
            )
            shadowLeftTop = CGPoint(
                x: boxLeftTop.x + offset * cos(-radians),
                y: boxLeftTop.y + offset * sin(-radians)
            )


            shadowLidLeftTop = CGPoint(
                x: boxLeftTop.x + (boxSize.width / 2.0 + offset)  * cos(-radians),
                y: boxLeftTop.y + (boxSize.width / 2.0 + offset) * sin(-radians)
            )

            shadowLidRightTop = CGPoint(
                x: boxRightTop.x - (boxSize.width / 2.0 + offset) * cos(radians),
                y: boxRightTop.y - (boxSize.width / 2.0 + offset) * sin(radians)
            )
        } else {
            shadowRightTop = CGPoint(x: boxRightTop.x, y: boxRightTop.y - offset)
            shadowLeftTop = CGPoint(x: boxLeftTop.x, y: boxLeftTop.y - offset)

            shadowLidLeftTop = CGPoint(x: boxLidLeftTop.x, y: boxLidLeftTop.y - offset)
            shadowLidRightTop = CGPoint(x: boxLidRightTop.x, y: boxLidRightTop.y - offset)
        }

        return Path { path in

            // box
            path.move(to: boxLeftTop)
            path.addLine(to: boxLeftBot)
            path.addLine(to: boxRightBot)
            path.addLine(to: boxRightTop)
            path.closeSubpath()

            // hole

            path.move(to: shadowLeftTop)
            path.addLine(to: boxLeftTop)
            path.addLine(to: boxRightTop)
            path.addLine(to: shadowRightTop)
            path.closeSubpath()

            // box left lid

            path.move(to: boxLeftTop)
            path.addLine(to: boxLidLeftTop)
            path.addLine(to: shadowLidLeftTop)
            path.addLine(to: shadowLeftTop)
            path.closeSubpath()

            // box right lid

            path.move(to: boxRightTop)
            path.addLine(to: boxLidRightTop)
            path.addLine(to: shadowLidRightTop)
            path.addLine(to: shadowRightTop)
            path.closeSubpath()
        }
    }
}
