//
//  WebSocketManager.swift
//  TradeQuotes
//
//  Created by Sergio Veliz on 09.03.2023.
//

import Foundation

protocol WebSocketManagerDelegate: AnyObject {
    func socketDidConnect(_ webSocketManager: WebSocketManager)
    func socketDidDisconnect(_ webSocketManager: WebSocketManager)
    func socketDidReceiveMessage(_ webSocketManager: WebSocketManager, didReceiveMessage message: String)
    func socketFailWithError(_ webSocketManager: WebSocketManager, failWithError error: Error)
}

class WebSocketManager: NSObject {
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    private var baseURL: String = "wss://wss.tradernet.ru"
    
    weak var delegate: WebSocketManagerDelegate?
    
    
    
    func connect() {
        guard webSocketTask == nil else { return }
        let url = URL(string: baseURL)!
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        webSocketTask = urlSession?.webSocketTask(with: url)
        
        webSocketTask?.resume()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        urlSession = nil
    }
    
    func send(text: [String]) {
        guard let quotesJSONData = try? JSONSerialization.data(withJSONObject: text),
              let quotesJSONString = String(data: quotesJSONData, encoding: .utf8) else { return }
        
        let string = "[\"realtimeQuotes\", \(quotesJSONString)]"
        let messageData = URLSessionWebSocketTask.Message.data(Data(string.utf8))
        webSocketTask?.send(messageData) { error in
            if let error = error {
                self.delegate?.socketFailWithError(self, failWithError: error)
            }
        }
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        delegate?.socketDidConnect(self)
        subscribe(to: webSocketTask)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            delegate?.socketFailWithError(self, failWithError: error)
        }
    }
    
    private func subscribe(to webSocketTask: URLSessionWebSocketTask) {
        webSocketTask.receive { result in
            switch result {
            case .failure(let error):
                self.delegate?.socketFailWithError(self, failWithError: error)
            case .success(let message):
                switch message {
                case .string(let text):
                    self.delegate?.socketDidReceiveMessage(self, didReceiveMessage: text)
                case .data(let data):
                    print("Received binary message: \(data)")
                @unknown default:
                    fatalError()
                }
            }
            self.subscribe(to: webSocketTask)
        }
    }
}
