//
//  QuotesViewModel.swift
//  TradeQuotes
//
//  Created by Sergio Veliz on 09.03.2023.
//

import Foundation

protocol QuotesViewModelDelegate: AnyObject {
    func reloadData()
    func refreshTableViewCell(at index: Int)
}

class QuotesViewModel {
    private var quoteModels: [QuoteUIModel] = []
    private let webService: WebSocketManager
    
    weak var delegate: QuotesViewModelDelegate?
    
    let tickersToWatchChanges = ["RSTI","GAZP","MRKZ","RUAL","HYDR","MRKS","SBER","FEES","TGKA",
                                 "VTBR","ANH.US","VICL.US","BURG.US","NBL.US","YETI.US","WSFS.US",
                                 "NIO.US","DXC.US","MIC.US","HSBC.US","EXPN.EU","GSK.EU","SHP.EU",
                                 "MAN.EU","DB1.EU","MUV2.EU","TATE.EU","KGF.EU","MGGT.EU","SGGD.EU"]
    
    init() {
        self.webService = WebSocketManager()
        self.webService.delegate = self
        
        let quoteModels = tickersToWatchChanges.map {
            QuoteUIModel(quote: QuoteInfo(c: $0, ltr: "", name2: "", pcp: 0, ltp: 0, chg: 0), state: .positive)
        }
        self.quoteModels = quoteModels
        self.delegate?.reloadData()
    }
    
    func connect() {
        self.webService.connect()
    }
    
    func disconnect() {
        self.webService.disconnect()
    }
    
    func sendSignal(_ message: String) {
        self.webService.send(text: tickersToWatchChanges)
    }
    
    func numberOfQuotes() -> Int {
        return quoteModels.count
    }
    
    func quote(at index: Int) -> QuoteUIModel {
        return quoteModels[index]
    }
    
    private func didQuoteChange(quote: QuoteInfo) {
        if let index = self.quoteModels.firstIndex(where: { $0.quote.c == quote.c }) {
            let currentQuoteModel = self.quoteModels[index]
            
            if let exchange = quote.ltr, let name = quote.name2 {
                currentQuoteModel.quote.ltr = exchange
                currentQuoteModel.quote.name2 = name
            }
            
            if let currentPercentChange = currentQuoteModel.quote.pcp {
                if let newPercentChange = quote.pcp {
                    if newPercentChange == currentPercentChange {
                        currentQuoteModel.state = currentPercentChange >= 0 ? .positive : .negative
                    } else {
                        currentQuoteModel.state = newPercentChange > currentPercentChange ? .up : .down
                    }
                    currentQuoteModel.quote.pcp = newPercentChange
                }
            }
            
            if let latestPrice = quote.ltp, let latestPriceChange = quote.chg {
                currentQuoteModel.quote.ltp = latestPrice
                currentQuoteModel.quote.chg = latestPriceChange
            }
            
            self.delegate?.refreshTableViewCell(at: index)
            
        }
    }
}

extension QuotesViewModel: WebSocketManagerDelegate {
    
    func socketDidConnect(_ webSocketManager: WebSocketManager) {
        print("socketDidConnect: \(webSocketManager)")
        webService.send(text: tickersToWatchChanges)
    }
    
    func socketDidDisconnect(_ webSocketManager: WebSocketManager) {
        print("socketDidDisconnect: \(webSocketManager)")
    }
    
    func socketDidReceiveMessage(_ webSocketManager: WebSocketManager, didReceiveMessage message: String) {
        do {
            if
                let data = message.data(using: .utf8),
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray,
                let lastObject = jsonArray.lastObject
            {
                let data = try JSONSerialization.data(withJSONObject: lastObject)
                let quote = try JSONDecoder().decode(QuoteInfo.self, from: data)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.didQuoteChange(quote: quote)
                }
            }
        } catch {
            print("socketDidReceiveMessage: can't parse quote")
        }
        webService.send(text: tickersToWatchChanges)
    }
    
    func socketFailWithError(_ webSocketManager: WebSocketManager, failWithError error: Error) {
        print("socketFailWithError: \(error)")
    }
}
