//
//  Constants.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-10-24.
//  Copyright © 2016 breadwallet LLC. All rights reserved.
//

import UIKit

let π: CGFloat = .pi

struct Padding {
    subscript(multiplier: Int) -> CGFloat {
        get {
            return CGFloat(multiplier) * 8.0
        }
    }
}

struct C {
    static let padding = Padding()
    struct Sizes {
        static let buttonHeight: CGFloat = 90.0
        static let headerHeight: CGFloat = 65.0
        static let largeHeaderHeight: CGFloat = 220.0
        static let logoAspectRatio: CGFloat = 239.0/400.0
    }
    static var defaultTintColor: UIColor = {
        return UIView().tintColor
    }()
    static let animationDuration: TimeInterval = 0.3
    static let secondsInDay: TimeInterval = 86400
    static let maxMoney: UInt64 = 21000000*100000000
    static let satoshis: UInt64 = 100000000
    static let walletQueue = "co.dogecwallet.walletqueue"
    static let btcCurrencyCode = "DOGEC"
    static let null = "(null)"
    static let maxMemoLength = 250
    static let feedbackEmail = "support@dogecwallet.co"
    static let reviewLink = "https://itunes.apple.com/app/hodl-wallet/id1382342568?action=write-review"
    static var standardPort: Int {
        return E.isTestnet ? 18333 : 56740
    }
    static let feeLimit: UInt64 = 1200000
    static let byteShift: UInt64 = 1000
    static let marginTop: CGFloat = 59.0
    static let marginBottom: CGFloat = 35.0
}
