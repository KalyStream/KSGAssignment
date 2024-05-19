//
//  LiveViewController.swift
//  KSGAssignment
//
//  Created by Kalybay Zhalgasbay on 19.05.2024.
//

import UIKit

public protocol ILiveView: AnyObject {
    func updateBufferData(data: [ItemViewModel])
}

class LiveViewController: UIViewController, UITableViewDelegate {
    
    var presenter: ILivePresenter?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = false
        tableView.register(LiveItemCell.self, forCellReuseIdentifier: LiveItemCell.identifier)
        return tableView
    }()
    private lazy var connectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Connect", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        return button
    }()
    private let infoView: InfoView = {
        let view = InfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var dataSource: UITableViewDiffableDataSource<Int, ItemViewModel>!
    private var data = [ItemViewModel]()
    private var bufferData = [ItemViewModel]()
    private var updateTimer: Timer?
    private var isUpdatingTable = false

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupConstraints()
        setupDataSource()
        setupUpdateTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.socketDisconnectTapped()
        bufferData = []
        data = []
        infoView.isHidden = false
        tableView.isHidden = true
    }

    func setupConstraints() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(infoView)
        view.addSubview(connectButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: connectButton.topAnchor, constant: -20),
            
            infoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            infoView.leftAnchor.constraint(equalTo: view.leftAnchor),
            infoView.rightAnchor.constraint(equalTo: view.rightAnchor),
            infoView.bottomAnchor.constraint(equalTo: connectButton.topAnchor, constant: -20),
            
            connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            connectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            connectButton.widthAnchor.constraint(equalToConstant: 160),
            connectButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, ItemViewModel>(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LiveItemCell.identifier, for: indexPath) as? LiveItemCell else {
                return UITableViewCell()
            }
            cell.configure(item: item)
            return cell
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ItemViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    @objc func connectButtonTapped() {
        guard let status = WebSocketHelper.shared.getStatus() else { return }
        switch status {
        case .connected, .connecting:
            presenter?.socketDisconnectTapped()
            connectButton.setTitle("P2P Live paused", for: .normal)
        case .disconnected, .notConnected:
            infoView.isHidden = true
            tableView.isHidden = false
            connectButton.setTitle("P2P Live activated", for: .normal)
            presenter?.socketConnectTapped()
        }
    }
    
    @objc func updateTableView(sender: Timer) {
        guard !bufferData.isEmpty else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.data.insert(contentsOf: self?.bufferData ?? [], at: 0)
            self?.bufferData.removeAll()
            self?.applySnapshot()
        }
    }
    
    private func setupUpdateTimer() {
        updateTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateTableView), userInfo: nil, repeats: true)
    }
}


extension LiveViewController: ILiveView {
    func updateBufferData(data: [ItemViewModel]) {
        DispatchQueue.main.async {
            self.bufferData.append(contentsOf: data)
        }
    }
}


extension LiveViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            presenter?.socketPaused()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            checkIfAtTop(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkIfAtTop(scrollView)
    }
    
    private func checkIfAtTop(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            presenter?.socketResumed()
        }
    }
}
