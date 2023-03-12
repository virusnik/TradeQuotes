//
//  QuotesViewModel.swift
//  TradeQuotes
//
//  Created by Sergio Veliz on 09.03.2023.
//

import Foundation

protocol QuotesViewModelDelegate: AnyObject {
    func reloadData()
}

class QuotesViewModel {
    private var quotes: [QuoteInfo] = []
    
    private let webService: WebSocketManager
    
    weak var delegate: QuotesViewModelDelegate?
       
       init() {
           self.webService = WebSocketManager()
           self.webService.delegate = self
       }
       
       func connect() {
           self.webService.connect()
       }
       
       func disconnect() {
           self.webService.disconnect()
       }
       
       func sendSignal(_ message: String) {
           self.webService.sendSignal()
       }
    
    func numberOfQuotes() -> Int {
        return quotes.count
    }
    
    func quote(at index: Int) -> QuoteInfo {
        return quotes[index]
    }
}

extension QuotesViewModel: WebSocketManagerDelegate {
    func webSocketManagerDidConnect(_ webSocketManager: WebSocketManager) {
        print("webSocketManagerDidConnect: \(webSocketManager)")
        webService.sendSignal()
    }
    
    func webSocketManagerDidDisconnect(_ webSocketManager: WebSocketManager) {
        print("webSocketManagerDidDisconnect: \(webSocketManager)")
    }
    
    func webSocketManager(_ webSocketManager: WebSocketManager, didReceiveMessage message: String) {
        print("didReceiveMessage : \(message)")
        
        do {
            if
                let data = message.data(using: .utf8),
                let jsonArray = try JSONSerialization.jsonObject(
                    with: data,
                    options: .allowFragments
                ) as? NSArray,
                let lastObject = jsonArray.lastObject
            {
                let data = try JSONSerialization.data(withJSONObject: lastObject)
                let model = try JSONDecoder().decode(QuoteInfo.self, from: data)
//                quotes.append(model)
                delegate?.reloadData()
            }
        } catch {}
        webService.sendSignal()
    }
    
    func webSocketManager(_ webSocketManager: WebSocketManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
    }
}
