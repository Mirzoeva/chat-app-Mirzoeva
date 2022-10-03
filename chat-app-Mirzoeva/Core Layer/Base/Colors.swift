//
//  Colors.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 17.03.2022.
//

import UIKit

internal enum Colors {
    internal static let black = ColorAsset(name: "black")
    internal static let brownGrey = ColorAsset(name: "brownGrey")
    internal static let iceBlue = ColorAsset(name: "iceBlue")
    internal static let lowerGray = ColorAsset(name: "lowerGray")
    internal static let orangeyRed = ColorAsset(name: "orangeyRed")
    internal static let rustyRed = ColorAsset(name: "rustyRed")
    internal static let yellow = ColorAsset(name: "yellow")
    internal static let squarePatternFirst = ColorAsset(name: "square.pattern.first")
    internal static let squarePatternSecond = ColorAsset(name: "square.pattern.second")
    internal static let upperGray = ColorAsset(name: "upperGray")
    internal static let veryLightPink = ColorAsset(name: "veryLightPink")
    internal static let white = ColorAsset(name: "white")
    internal static let dayTheme = UIColor().colorFromHexString("ffe2df")
    internal static let classicTheme = ColorAsset(name: "white")
    internal static let nightTheme = ColorAsset(name: "black")
}

internal final class ColorAsset {
    internal fileprivate(set) var name: String
    internal typealias Color = UIColor
    internal private(set) lazy var color: Color = {
        guard let color = Color(asset: self) else {
            fatalError("Unable to load color asset named \(name).")
        }
        return color
    }()
    
    fileprivate init(name: String) {
        self.name = name
    }
}

internal extension ColorAsset.Color {
    convenience init?(asset: ColorAsset) {
        let bundle = BundleToken.bundle
        self.init(named: asset.name, in: bundle, compatibleWith: nil)
    }
}

private final class BundleToken {
    static let bundle: Bundle = {
        Bundle(for: BundleToken.self)
    }()
}
