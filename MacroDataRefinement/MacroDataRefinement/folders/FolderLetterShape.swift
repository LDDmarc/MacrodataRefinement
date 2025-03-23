//
//  FolderLetterShape.swift
//  MacroDataRefinement
//
//  Created by Дарья Леонова on 19.03.2025.
//

import SwiftUI

struct RoundedTrapezoid: Shape {
    var topWidthFactor: CGFloat = 0.7
    var cornerRadius: CGFloat = 4.0
    
    func path(in rect: CGRect) -> Path {
        // Compute the top edge width based on the given factor.
        let topWidth = rect.width * topWidthFactor
        // Center the top edge horizontally.
        let midX = rect.midX

        // Define the four corner points of the trapezoid.
        // Top edge is centered, bottom edge spans the full width.
        let topLeft = CGPoint(x: midX - topWidth / 2, y: rect.minY)
        let topRight = CGPoint(x: midX + topWidth / 2, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        var path = Path()

        path.move(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        path.addArc(tangent1End: topLeft, tangent2End: topRight, radius: cornerRadius)

        path.addLine(to: CGPoint(x: topRight.x - cornerRadius, y: topRight.y))
        path.addArc(tangent1End: topRight, tangent2End: bottomRight, radius: cornerRadius)

        path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))

        return path
    }
}

#Preview {
    Text("A")
        .font(.system(size: 150))
        .padding(.vertical, 0)
        .padding(.horizontal, 80)
        .background(
            RoundedTrapezoid()
                .stroke(Color.black, lineWidth: 15)
                .fill(Color.yellow)
        )
        .padding()

}
