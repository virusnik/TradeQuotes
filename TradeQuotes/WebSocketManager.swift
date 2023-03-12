//
//  WebSocketManager.swift
//  TradeQuotes
//
//  Created by Sergio Veliz on 09.03.2023.
//

import Foundation

protocol WebSocketManagerDelegate: AnyObject {
    func webSocketManagerDidConnect(_ webSocketManager: WebSocketManager)
    func webSocketManagerDidDisconnect(_ webSocketManager: WebSocketManager)
    func webSocketManager(_ webSocketManager: WebSocketManager, didReceiveMessage message: String)
    func webSocketManager(_ webSocketManager: WebSocketManager, didFailWithError error: Error)
}

class WebSocketManager: NSObject {
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    private var baseURL: String = "wss://wss.tradernet.ru"
    
    weak var delegate: WebSocketManagerDelegate?
    
    let tickersToWatchChanges = ["RSTI", "GAZP", "MRKZ", "RUAL", "HYDR", "MRKS", "SBER", "FEES", "TGKA", "VTBR,ANH.US", "VICL.US", "BURG. US", "NBL.US", "YETI.US", "WSFS.US", "NIO.US", "DXC.US", "MIC.US", "HSBC.US", "EXPN.EU", "GSK.EU","SH P.EU", "MAN.EU", "DB1.EU", "MUV2.EU", "TATE.EU", "KGF.EU", "MGGT.EU", "SGGD.EU"]
    
    func connect() {
        guard webSocketTask == nil else { return }
        let url = URL(string: baseURL)!
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        webSocketTask = urlSession?.webSocketTask(with: url)
        
        webSocketTask?.resume()
        sendSignal()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        urlSession = nil
    }
    
    func sendSignal() {
        guard let quotesJSONData = try? JSONSerialization.data(withJSONObject: tickersToWatchChanges),
              let quotesJSONString = String(data: quotesJSONData, encoding: .utf8) else { return }
        
        let string = "[\"realtimeQuotes\", \(quotesJSONString)]"
        let messageData = URLSessionWebSocketTask.Message.data(Data(string.utf8))
        webSocketTask?.send(messageData) { error in
            if let error = error {
                self.delegate?.webSocketManager(self, didFailWithError: error)
            }
        }
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        delegate?.webSocketManagerDidConnect(self)
        subscribe(to: webSocketTask)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            delegate?.webSocketManager(self, didFailWithError: error)
        }
    }
    
    private func subscribe(to webSocketTask: URLSessionWebSocketTask) {
        webSocketTask.receive { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.webSocketManager(self!, didFailWithError: error)
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.delegate?.webSocketManager(self!, didReceiveMessage: text)
                case .data(let data):
                    print("Received binary message: \(data)")
                @unknown default:
                    fatalError()
                }
            }
            self?.subscribe(to: webSocketTask)
        }
    }
}
