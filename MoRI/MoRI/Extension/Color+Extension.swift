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
    // 예시
//    static let neu100 = Color(hex: 0xE6E6E6)
//    static let neu200 = Color(hex: 0xBFBFBF)
//    static let neu300 = Color(hex: 0x999999)
//    static let neu400 = Color(hex: 0x737373)
//    static let neu500 = Color(hex: 0x4D4D4D)
//    static let neu600 = Color(hex: 0x262626)
//    static let neu700 = Color(hex: 0x000000)
//
//    static let main100 = Color(hex: 0xBA9DF9)
//    static let main200 = Color(hex: 0xA984F9)
//    static let main300 = Color(hex: 0x986BF9)
//    static let main400 = Color(hex: 0x8752F9)
//    static let main500 = Color(hex: 0x7638F9)
//    static let main600 = Color(hex: 0x6620F9)
//    static let main700 = Color(hex: 0x5507F9)
//
//    static let blue500 = Color(hex: 0x008BFF)
//
//    static let cyan500 = Color(hex: 0x4EFCE0)
}
