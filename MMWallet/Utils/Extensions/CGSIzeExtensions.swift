//
//  CGSIzeExtensions.swift
//  Wallet
//
//  Created by Oleg Leizer on 13.06.2018.
//  Copyright © 2018 Oleg Leizer. All rights reserved.
//
import UIKit
extension CGSize {
    static let minButton = CGSize(width: 40, height: 40)

    var integral: CGSize {
        return CGSize(width: ceil(width), height: ceil(height))
    }

    func scaledSize(_ maxSize: CGSize) -> CGSize {
        var newSize = self
        if newSize.width > maxSize.width {
            let scale = maxSize.width / newSize.width
            newSize = CGSize(width: newSize.width * scale, height: newSize.height * scale)
        }
        if newSize.height > maxSize.height {
            let scale = maxSize.height / newSize.height
            newSize = CGSize(width: newSize.width * scale, height: newSize.height * scale)
        }
        return newSize
    }
}
