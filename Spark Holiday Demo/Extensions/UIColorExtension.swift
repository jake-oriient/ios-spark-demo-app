//
//  UIColorExtension.swift
//  Spark Holiday Demo
//
//  Created by Jake Dunahee on 6/9/26.
//

import UIKit

extension UIColor {
    
    convenience init?(hex: String) {
        var cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cleanedHex.hasPrefix("#") {
            cleanedHex.removeFirst()
        }
        
        guard cleanedHex.count == 6 || cleanedHex.count == 8 else { return nil }
        
        var rgbValue: UInt64 = 0
        let scanner = Scanner(string: cleanedHex)
        
        guard scanner.scanHexInt64(&rgbValue) else { return nil }
        
        let r, g, b, a: CGFloat
        if cleanedHex.count == 6 {
            r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgbValue & 0x0000FF) / 255.0
            a = 1.0
        } else {
            r = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgbValue & 0x000000FF) / 255.0
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
}
