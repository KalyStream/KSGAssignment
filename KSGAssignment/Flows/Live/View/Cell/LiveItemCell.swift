//
//  ItemCell.swift
//  KSGAssignment
//
//  Created by Kalybay Zhalgasbay on 19.05.2024.
//

import UIKit

enum LiveItemState {
    case new
    case remove
    case update
    
    var backgroundColor: UIColor {
        switch self {
        case .new:    return UIColor.green
        case .remove: return UIColor.red
        case .update: return UIColor.link
        }
    }
    
    var titleText: String {
        switch self {
        case .new:    return "New"
        case .remove: return "Removed"
        case .update: return "Updated"
        }
    }
}

final class LiveItemCell: UITableViewCell {
    
    static let identifier = "LiveItemCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        imageView.image = UIImage(systemName: "hexagon")
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    private let classidLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        classidLabel.text = nil
        priceLabel.text = nil
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(classidLabel)
        containerView.addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            classidLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            classidLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            classidLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            priceLabel.topAnchor.constraint(equalTo: classidLabel.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            priceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(item: ItemViewModel) {
        containerView.backgroundColor = item.state.backgroundColor
        nameLabel.text = item.nameText
        classidLabel.text = "Class ID: \(item.classidText)"
        priceLabel.text = "Price: $\(item.priceText)"
    }
}
