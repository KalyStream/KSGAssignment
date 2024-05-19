//
//  Extensions.swift
//  KSGAssignment
//
//  Created by Kalybay Zhalgasbay on 19.05.2024.
//

import UIKit

public extension UIApplication {
    
    static var window: UIWindow? {
        return (UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first { $0.isKeyWindow })
    }
}
