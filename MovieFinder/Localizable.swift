//
//  Localization.swift
//  mlf
//
//  Created by Yosif Iliev on 22.11.18.
//  Copyright © 2018 Yosif Iliev. All rights reserved.
//

import UIKit

protocol Localizable {
    var localized: String { get }
}

protocol XIBLocalizable {
    var localizedKey: String? { get set }
}

extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UILabel: XIBLocalizable {
    @IBInspectable var localizedKey: String? {
        get { return nil }
        set (key) {
            text = key?.localized
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable var localizedKey: String? {
        get { return nil }
        set (key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}

extension UITextField: XIBLocalizable {
    @IBInspectable var localizedKey: String? {
        get { return nil }
        set (key) {
            placeholder = key?.localized
        }
    }
}

