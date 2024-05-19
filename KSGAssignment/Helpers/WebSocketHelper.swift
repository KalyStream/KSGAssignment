//
//  WebSocketHelper.swift
//  KSGAssignmentWebSocket
//
//  Created by Kalybay Zhalgasbay on 18.05.2024.
//

import Foundation
import SocketIO
import UIKit
import Toast

protocol WebSocketHelperDelegate: AnyObject {
    func didReceiveEvent(data: [ItemViewModel])
}

class WebSocketHelper {
    weak var delegate: WebSocketHelperDelegate?
    static let shared = WebSocketHelper()
    private var manager: SocketManager
    private var socket: SocketIOClient?
    private var isPaused: Bool = false
    
    private init() {
        let url = URL(string: "https://waxpeer.com")!
        let cookies = HTTPCookieStorage.shared.cookies(for: url) ?? []
        let cookieHeaders = HTTPCookie.requestHeaderFields(with: cookies)
        manager = SocketManager(socketURL: url, config: [ .log(true), .extraHeaders(cookieHeaders), .forceWebsockets(true)])
        socket = manager.defaultSocket
        setupHandlers()
    }

    private func setupHandlers() {
        socket?.on(clientEvent: .connect) { [weak self] data, ack in
            print("Socket connected")
            self?.socket?.emit("subscribe", ["name": "csgo"])
        }
        
        socket?.on("new") { [weak self] data, ack in
            print("New event received: \(data)")
            guard let self = self, !self.isPaused else { return }
            DispatchQueue.global(qos: .userInteractive).async {
                self.handleEvent(data: data, eventType: "new")
            }
        }
        
        socket?.on("removed") { [weak self] data, ack in
            print("Removed event received: \(data)")
            guard let self = self, !self.isPaused else { return }
            DispatchQueue.global(qos: .userInteractive).async {
                self.handleEvent(data: data, eventType: "removed")
            }
        }
        
        socket?.on("update") { [weak self] data, ack in
            print("Update event received: \(data)")
            guard let self = self, !self.isPaused else { return }
            DispatchQueue.global(qos: .userInteractive).async {
                self.handleEvent(data: data, eventType: "update")
            }
        }

        socket?.on(clientEvent: .disconnect) { data, ack in
            print("Socket disconnected")
        }

        socket?.on(clientEvent: .error) { [weak self] data, ack in
            print("Socket error: \(data)")
            self?.showToast(message: "Error occured, try reconnecting...", type: .error)
            self?.retryConnection()
        }
        
        socket?.on(clientEvent: .statusChange) { [weak self] data, ack in
            print("Status changed: \(data)")
            switch self?.socket?.status {
            case .connecting:
                self?.showToast(message: "Connecting...", type: .processing)
            case .connected:
                self?.showToast(message: "Socket connected.", type: .success)
            case .disconnected:
                self?.showToast(message: "Socket disconnected.", type: .error)
            case .notConnected:
                self?.showToast(message: "Not connected", type: .normal)
            default:
                break
            }
        }
        
        socket?.on(clientEvent: .ping) { data, ack in
            print("Ping: \(data)")
        }
        
        socket?.on(clientEvent: .pong) { data, ack in
            print("Pong: \(data)")
        }
    }
    
    private func handleEvent(data: [Any], eventType: String) {
           do {
               let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
               let decodedData = try JSONDecoder().decode([ItemResponse].self, from: jsonData)

               switch eventType {
               case "new":
                   let itemViewModel = decodedData.map { ItemViewModel(item: $0, state: .new)}
                   delegate?.didReceiveEvent(data: itemViewModel)
               case "removed":
                   let itemViewModel = decodedData.map { ItemViewModel(item: $0, state: .remove)}
                   delegate?.didReceiveEvent(data: itemViewModel)
               case "update":
                   let itemViewModel = decodedData.map { ItemViewModel(item: $0, state: .update)}
                   delegate?.didReceiveEvent(data: itemViewModel)
               default:
                   break
               }
           } catch {
               print("Error decoding \(eventType) event: \(error.localizedDescription)")
           }
       }

    func connect() {
        socket?.connect()
    }

    func disconnect() {
        socket?.disconnect()
    }
    
    func pause() {
        isPaused = true
    }
    
    func resume() {
        isPaused = false
    }
    
    func getStatus() -> SocketIOStatus? {
        socket?.status
    }

    private func retryConnection() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.socket?.connect()
        }
    }
}


extension WebSocketHelper {
    
    enum ToastType {
        case normal
        case error
        case processing
        case success
        
        var backgroundColor: UIColor {
            switch self {
            case .error:       return .red
            case .success:     return .green
            case .normal:      return .gray
            case .processing: return .link
            }
        }
    }
    
    func showToast(message: String, type: ToastType) {
        var style = ToastStyle()
        style.messageColor = .black
        style.messageFont = .systemFont(ofSize: 14)
        style.messageAlignment = .center
        style.backgroundColor = type.backgroundColor
        style.cornerRadius = 23
        style.verticalPadding = 15
        style.horizontalPadding = 16
        style.displayShadow = false

        let window = UIApplication.window
        window?.makeToast(message, position: .top, style: style)
    }
}
