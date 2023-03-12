//
//  QuoteInfo.swift
//  TradeQuotes
//
//  Created by Sergio Veliz on 09.03.2023.
//

import Foundation

struct QuoteArray: Decodable {
    let q: QuoteInfo
}

struct QuoteInfo: Decodable {
    // ticker
    let c: String
    // lastPrice
    let ltr: String?
    // latins name
    let name2: String?
    // change percents
    var pcp: Double?
    // last transaction price
    var ltp: Double?
    // change price last transaction in points
    var chg: Double?
}


class QuoteUIModel {
    enum State {
        case positive
        case negative
    }
    var quote: QuoteInfo
    var state: State
    
    init(quote: QuoteInfo, state: State) {
        self.quote = quote
        self.state = state
    }
}
