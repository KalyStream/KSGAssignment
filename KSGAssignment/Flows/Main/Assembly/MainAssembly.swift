//
//  MainAssembly.swift
//  KSGAssignment
//
//  Created by Kalybay Zhalgasbay on 19.05.2024.
//

import UIKit

public final class MainAssembly {
    
    func makeMainModule() -> UIViewController {
        let view = MainViewController()
        let liveAssembly = LiveAssembly()
        let router: IMainRouter = MainRouter(rootView: view, liveAssembly: liveAssembly)
        let presenter: IMainPresenter = MainPresenter(router: router, view: view)
        view.presenter = presenter
        return view
    }
}
