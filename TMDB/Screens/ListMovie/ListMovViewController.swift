//
//  ListMovViewController.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import UIKit

class ListMovViewController: UIViewController, ListMovViewProtocol {
    
    var presenter: ListMovPresenterProtocol?
    
    private let debouncer = Debouncer(delay: 0.5)
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
        textField.returnKeyType = .search
        textField.backgroundColor = .gray.withAlphaComponent(0.3)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Search..."
        textField.clearButtonMode = .always
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieListCell.self, forCellReuseIdentifier: MovieListCell.identifierString)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private lazy var offlineModeView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var offlineLabel: UILabel = {
        let label = UILabel()
        label.text = "You are in offline mode"
        return label
    }()
    
    private lazy var reconnectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reconnect", for: .normal)
        button.addTarget(self, action: #selector(reconnect), for: .touchUpInside)
        button.backgroundColor = .gray.withAlphaComponent(0.3)
        return button
    }()
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()

        view.addSubview(tableView)
        view.addSubview(headerView)
        view.addSubview(offlineModeView)
        
        headerView.addSubview(searchTextField)
        
        offlineModeView.addSubview(offlineLabel)
        offlineModeView.addSubview(reconnectButton)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reconnect),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
        
        presenter?.view = self
        presenter?.onViewReadyToLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        headerView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: view.frame.width,
                                  height: statusbarHeight + 44)
        offlineModeView.frame = CGRect(x: 0,
                                       y: headerView.frame.maxY,
                                       width: view.frame.width,
                                       height: 44)
        let tableTopView = offlineModeView.isHidden ? headerView : offlineModeView
        tableView.frame = CGRect(x: 0,
                                 y: tableTopView.frame.maxY,
                                 width: view.frame.width,
                                 height: view.frame.height - tableTopView.frame.maxY)
        searchTextField.frame = CGRect(x: UIConst.padding,
                                       y: statusbarHeight + 4,
                                       width: view.frame.width - 2*UIConst.padding,
                                       height: 44 - 8)
        offlineLabel.frame = CGRect(x: UIConst.padding,
                                    y: 0,
                                    width: view.frame.width - UIConst.padding - 100,
                                    height: offlineModeView.frame.height)
        reconnectButton.frame = CGRect(x: view.frame.width - UIConst.padding - 100,
                                       y: 4,
                                       width: 100,
                                       height: 36)
        reconnectButton.layer.cornerRadius = 36/2
    }
    
    @objc private func textFieldTextDidChange() {
        debouncer.run { [weak self] in
            self?.presenter?.search(kw: self?.searchTextField.text)
        }
    }
    
    @objc private func onBecomeActive() {
        if !offlineModeView.isHidden {
            reconnect()
        }
    }
    
    @objc private func reconnect() {
        presenter?.tryLoadRemote()
    }
    
    //MARK: - ListMovViewProtocol
    
    func displayOfflineMode(isOffline: Bool) {
        offlineModeView.isHidden = !isOffline
        view.setNeedsLayout()
    }
    
    func displayData() {
        tableView.setContentOffset(.zero, animated: false)
        tableView.reloadData()
    }
    
    func appendData(indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func displayError(error: Error) {
        let alert = UIAlertController(
            title: "Failed to load data",
            message: "Please try again",
            preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(
            title: "Retry",
            style: UIAlertAction.Style.default,
            handler: { [weak self] _ in
                self?.presenter?.onViewReadyToLoad()
            }))
        
        present(alert, animated: true, completion: nil)
    }
        
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ListMovViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRow() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.identifierString, for: indexPath)
        if let movieCell = cell as? MovieListCell,
           let movie = presenter?.getMovieAtIndex(index: indexPath.row) {
            movieCell.bind(movie: movie)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = presenter?.getMovieAtIndex(index: indexPath.row) {
            let presenter = MovieDetailPresenter(movId: movie.id)
            let vc = MovieDetailViewController()
            vc.presenter = presenter
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        presenter?.onScrollViewDidScroll(scrollView)
    }
}

//MARK: - UITextFieldDelegate

extension ListMovViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
}
