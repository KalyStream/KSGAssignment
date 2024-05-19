//
//  InfoView.swift
//  KSGAssignment
//
//  Created by Kalybay Zhalgasbay on 19.05.2024.
//

import UIKit

class InfoView: UIView {
    
    private let items: [ItemViewModel] = [
        ItemViewModel(state: .new),
        ItemViewModel(state: .remove),
        ItemViewModel(state: .update)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        let mainStackView = UIStackView()
        items.forEach { mainStackView.addArrangedSubview(makeInfoView(item: $0)) }
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.spacing = 20
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func makeInfoView(item: ItemViewModel) -> UIView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        
        let colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.backgroundColor = item.state.backgroundColor
        colorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        colorView.layer.cornerRadius = 5
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.text = item.state.titleText
        
        stackView.addArrangedSubview(colorView)
        stackView.addArrangedSubview(label)
        return stackView
    }
}
