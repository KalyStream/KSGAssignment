//
//  LiveItemResponse.swift
//  KSGAssignment
//
//  Created by Kalybay Zhalgasbay on 19.05.2024.
//

import Foundation

struct ItemResponse: Decodable, Hashable {
    let classid: Int?
    let price: Int?
    let name: String?
}
