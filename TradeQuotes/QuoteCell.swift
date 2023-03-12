//
//  QuoteCell.swift
//  TradeQuotes
//
//  Created by Sergio Veliz on 09.03.2023.
//

import UIKit.UITableViewCell

class QuoteCell: UITableViewCell {
    
    static let reuseIdentifier = "QuoteCell"
    
    private let tickerLabel = UILabel()
    private let exchangeLabel = UILabel()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let changePercentLabel = UILabel()
    private let changePointsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tickerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        exchangeLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        changePercentLabel.font = UIFont.systemFont(ofSize: 14)
        changePointsLabel.font = UIFont.systemFont(ofSize: 14)
        
        contentView.addSubview(tickerLabel)
        contentView.addSubview(exchangeLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(changePercentLabel)
        contentView.addSubview(changePointsLabel)
        
        tickerLabel.translatesAutoresizingMaskIntoConstraints = false
        exchangeLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        changePercentLabel.translatesAutoresizingMaskIntoConstraints = false
        changePointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tickerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tickerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            exchangeLabel.leadingAnchor.constraint(equalTo: tickerLabel.trailingAnchor, constant: 8),
            exchangeLabel.topAnchor.constraint(equalTo: tickerLabel.topAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: tickerLabel.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: tickerLabel.bottomAnchor, constant: 8),
            
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            changePercentLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            changePercentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            changePointsLabel.leadingAnchor.constraint(equalTo: changePercentLabel.trailingAnchor, constant: 8),
            changePointsLabel.topAnchor.constraint(equalTo: changePercentLabel.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with quote: QuoteInfo) {
        tickerLabel.text = quote.c
        exchangeLabel.text = quote.ltr
        nameLabel.text = quote.name2
        priceLabel.text = "\(quote.ltp)"
        changePercentLabel.text = "\(quote.pcp)"
        changePointsLabel.text = "\(quote.chg)"
        
        if quote.chg ?? 0 >= 0 {
            priceLabel.textColor = .green
            changePercentLabel.textColor = .green
            changePointsLabel.textColor = .green
        } else {
            priceLabel.textColor = .red
            changePercentLabel.textColor = .red
            changePointsLabel.textColor = .red
        }
    }
}
