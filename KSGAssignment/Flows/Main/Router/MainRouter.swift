//
//  MainRouter.swift
//  KSGAssignment
//
//  Created by Kalybay Zhalgasbay on 19.05.2024.
//

import UIKit

public protocol IMainRouter: AnyObject {
    func presentLive()
}

public final class MainRouter: IMainRouter {
    
    weak var rootView: UIViewController?
    private let liveAssemlby: LiveAssembly
    
    init(rootView: UIViewController, liveAssembly: LiveAssembly) {
        self.rootView = rootView
        self.liveAssemlby = liveAssembly
    }
    
    public func presentLive() {
        let live = liveAssemlby.makeLiveModule()
        live.modalPresentationStyle = .overFullScreen
        rootView?.navigationController?.pushViewController(live, animated: true)
    }
}
