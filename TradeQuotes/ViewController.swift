//
//  ViewController.swift
//  TradeQuotes
//
//  Created by Sergio Veliz on 03.03.2023.
//

import UIKit

class QuotesViewController: UIViewController {
    
    // MARK: - Properties
        
    private var viewModel = QuotesViewModel()
        private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка таблицы
        tableView.dataSource = self
        tableView.register(QuoteCell.self, forCellReuseIdentifier: "QuoteCell")
        view.addSubview(tableView)
        
        // Установка констрейнтов для таблицы
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        self.viewModel.delegate = self
        viewModel.connect()
    }
}

// Реализация методов UITableViewDataSource
extension QuotesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfQuotes()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as! QuoteCell
        
        let quote = viewModel.quote(at: indexPath.row)
        cell.configure(with: quote)
        
        return cell
    }
}

extension QuotesViewController: QuotesViewModelDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

