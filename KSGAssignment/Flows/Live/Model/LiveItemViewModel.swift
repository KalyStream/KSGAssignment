//
//  LiveItemViewModel.swift
//  KSGAssignment
//
//  Created by Kalybay Zhalgasbay on 19.05.2024.
//

import Foundation

public struct ItemViewModel: Hashable {
    let id = UUID()
    let state: LiveItemState
    let classidText: String
    let priceText: String
    let nameText: String
    
    init(item: ItemResponse? = nil, state: LiveItemState) {
        self.state = state
        classidText = "\(item?.classid ?? 0)"
        priceText = "\(item?.price ?? 0)"
        nameText = item?.name ?? String()
    }
}
