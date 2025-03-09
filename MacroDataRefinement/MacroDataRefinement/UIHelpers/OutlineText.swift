////
////  OutlineText.swift
////  MacroDataRefinement
////
////  Created by Дарья Леонова on 07.03.2025.
////
//
//import SwiftUI
//import AppKit
//
//struct StrokeTextLabel: NSViewRepresentable {
//    func makeUIView(context: Context) -> NSLabel {
//        let attributedStringParagraphStyle = NSMutableParagraphStyle()
//        attributedStringParagraphStyle.alignment = NSTextAlignment.center
//        let attributedString = NSAttributedString(
//            string: "Classic",
//            attributes:[
//                NSAttributedString.Key.paragraphStyle: attributedStringParagraphStyle,
//                NSAttributedString.Key.strokeWidth: 3.0,
//                NSAttributedString.Key.foregroundColor: UIColor.black,
//                NSAttributedString.Key.strokeColor: UIColor.black,
//                NSAttributedString.Key.font: UIFont(name:"Helvetica", size:30.0)!
//            ]
//        )
//
//        let strokeLabel = UILabel(frame: CGRect.zero)
//        strokeLabel.attributedText = attributedString
//        strokeLabel.backgroundColor = UIColor.clear
//        strokeLabel.sizeToFit()
//        strokeLabel.center = CGPoint.init(x: 0.0, y: 0.0)
//        return strokeLabel
//    }
//
//    func updateUIView(_ uiView: UILabel, context: Context) {}
//}
//
//extension View {
//    func customeStrok(color: Color, width: CGFloat) -> some View {
//        self.modifier(StrokeModifier(strokeSize: width, strokeColor: color))
//    }
//}
//
//
//#Preview {
//    Text("Sample Text")
//        .customeStrok(color: Color.gray, width: 2)
//        .font(.system(size: 30, weight: .bold))
//        .foregroundStyle(Color.darkBlue)
//        .padding()
//        .background(Color.darkBlue)
//}
