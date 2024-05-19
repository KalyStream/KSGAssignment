//
//  LiveAssembly.swift
//  KSGAssignment
//
//  Created by Kalybay Zhalgasbay on 19.05.2024.
//

import UIKit

final class LiveAssembly {
    
    func makeLiveModule() -> UIViewController {
        let view = LiveViewController()
        let router: ILiveRouter = LiveRouter(rootView: view)
        let socketHelper = WebSocketHelper.shared
        let presenter: ILivePresenter = LivePresenter(router: router, view: view, socketHelper: socketHelper)
        view.presenter = presenter
        return view
    }
}
