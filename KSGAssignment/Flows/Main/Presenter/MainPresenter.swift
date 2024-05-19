//
//  MainPresenter.swift
//  KSGAssignment
//
//  Created by Kalybay Zhalgasbay on 19.05.2024.
//

import Foundation

public protocol IMainPresenter: AnyObject {
    func presentLive()
}

public class MainPresenter: IMainPresenter {
    
    private let router: IMainRouter
    private weak var view: IMainView?
    
    init(router: IMainRouter, view: IMainView) {
        self.router = router
        self.view = view
    }
    
    public func presentLive() {
        router.presentLive()
    }
}
