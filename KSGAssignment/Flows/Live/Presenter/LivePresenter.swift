//
//  LivePresenter.swift
//  KSGAssignment
//
//  Created by Kalybay Zhalgasbay on 19.05.2024.
//

import Foundation

public protocol ILivePresenter: AnyObject {
    func viewDidLoad()
    func socketConnectTapped()
    func socketDisconnectTapped()
    func socketPaused()
    func socketResumed()
}

public class LivePresenter: ILivePresenter {
    
    private var router: ILiveRouter
    private weak var view: ILiveView?
    let socketHelper: WebSocketHelper
    
    init(router: ILiveRouter, view: ILiveView, socketHelper: WebSocketHelper) {
        self.router = router
        self.view = view
        self.socketHelper = socketHelper
    }
    
    public func viewDidLoad() {
        socketHelper.delegate = self
    }
    
    public func socketConnectTapped() {
        socketHelper.connect()
    }
    
    public func socketDisconnectTapped() {
        socketHelper.disconnect()
    }
    
    public func socketPaused() {
        socketHelper.pause()
    }
    
    public func socketResumed() {
        socketHelper.resume()
    }
}


extension LivePresenter: WebSocketHelperDelegate {
    func didReceiveEvent(data: [ItemViewModel]) {
        view?.updateBufferData(data: data)
    }
}
