//
//  Color+Extension.swift
//  MoRI
//
//  Created by GYURI PARK on 2023/07/18.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
            let red = Double((hex >> 16) & 0xff) / 255.0
            let green = Double((hex >> 8) & 0xff) / 255.0
            let blue = Double(hex & 0xff) / 255.0
            self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    var components: (r: Double, g: Double, b: Double, a: Double) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else { return (0,0,0,0) }
        
        return (Double(r), Double(g), Double(b), Double(a))
    }
    static let primaryColor =  Color("primary")
    static let whiteColor =  Color("White")
    static let blackColor =  Color("black")
    static let gray01Color =  Color("gray01")
    static let gray02Color =  Color("gray02")
    static let gray03Color =  Color("gray03")
    static let gray04Color =  Color("gray04")
}
