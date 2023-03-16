//
//  PaddedLabel.swift
//  TradeQuotes
//
//  Created by Sergio Veliz on 16.03.2023.
//

import UIKit.UILabel

class PaddedLabel: UILabel {
    var padding: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
}
