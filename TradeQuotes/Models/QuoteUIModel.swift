//
//  QuoteUIModel.swift
//  TradeQuotes
//
//  Created by Sergio Veliz on 16.03.2023.
//

import Foundation

class QuoteUIModel {
    enum State {
        case positive
        case negative
        case up
        case down
    }
    var quote: QuoteInfo
    var state: State
    
    init(quote: QuoteInfo, state: State) {
        self.quote = quote
        self.state = state
    }
}
