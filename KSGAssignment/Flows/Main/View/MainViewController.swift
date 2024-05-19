//
//  MainViewController.swift
//  KSGAssignment
//
//  Created by Kalybay Zhalgasbay on 19.05.2024.
//

import UIKit

public protocol IMainView: AnyObject { }

public final class MainViewController: UIViewController {
    
    var presenter: IMainPresenter?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        imageView.image = UIImage(systemName: "hexagon")
        return imageView
    }()
    
    private lazy var openLiveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open Live", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(openLiveModule), for: .touchUpInside)
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(openLiveButton)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            
            openLiveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openLiveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            openLiveButton.widthAnchor.constraint(equalToConstant: 160),
            openLiveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func openLiveModule() {
        Vibration.selection.vibrate()
        presenter?.presentLive()
    }
}


extension MainViewController: IMainView { }
