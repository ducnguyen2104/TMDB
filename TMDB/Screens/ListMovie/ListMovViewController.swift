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
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()

        view.addSubview(tableView)
        view.addSubview(headerView)
        headerView.addSubview(searchTextField)
        
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
        tableView.frame = CGRect(x: 0,
                                 y: headerView.frame.maxY,
                                 width: view.frame.width,
                                 height: view.frame.height - headerView.frame.maxY)
        searchTextField.frame = CGRect(x: 16,
                                       y: statusbarHeight + 4,
                                       width: view.frame.width - 32,
                                       height: 44 - 8)
    }
    
    @objc private func textFieldTextDidChange() {
        debouncer.run { [weak self] in
            self?.presenter?.search(kw: self?.searchTextField.text)
        }
    }
    
    //MARK: - ListMovViewProtocol
    
    func displayData() {
        tableView.reloadData()
        tableView.setContentOffset(.zero, animated: false)
    }
    
    func appendData(indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func displayError(error: Error) {
        
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
