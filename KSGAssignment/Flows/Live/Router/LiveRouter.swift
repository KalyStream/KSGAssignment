//
//  LiveRouter.swift
//  KSGAssignment
//
//  Created by Kalybay Zhalgasbay on 19.05.2024.
//

import UIKit

public protocol ILiveRouter: AnyObject {
    
}

public final class LiveRouter: ILiveRouter {
    
    weak var rootView: UIViewController?
    
    init(rootView: UIViewController) {
        self.rootView = rootView
    }
}
