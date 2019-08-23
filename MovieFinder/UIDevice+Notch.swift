//
//  UIDevice+Notch.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 23.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}
