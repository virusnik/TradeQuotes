//
//  QuoteCell.swift
//  TradeQuotes
//
//  Created by Sergio Veliz on 09.03.2023.
//

import UIKit.UITableViewCell

class QuoteCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "QuoteCell"
    
    //MARK: - Subviews
    
    private lazy var tickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var changePercentLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.padding = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tickerLabel.text = nil
        nameLabel.text = nil
        priceLabel.text = nil
        changePercentLabel.text = nil
    }
    
    //MARK: - Constraints
    private func setupConstraints() {
        self.accessoryType = .disclosureIndicator
        contentView.addSubview(tickerLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(changePercentLabel)
        
        tickerLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        changePercentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tickerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tickerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            nameLabel.leadingAnchor.constraint(equalTo: tickerLabel.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: tickerLabel.bottomAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            priceLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            changePercentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            changePercentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            changePercentLabel.widthAnchor.constraint(equalToConstant: 70),
            changePercentLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    // MARK: - Configure data
    func configure(with item: QuoteUIModel) {
        tickerLabel.text = item.quote.c
        if let exchange = item.quote.ltr, let name = item.quote.name2 {
            nameLabel.text = "\(exchange) | \(name)"
        }
        if let percentText = item.quote.pcp {
            changePercentLabel.text = "\(percentText.withFormatPlusSign) %"
            
            switch item.state {
            case .negative:
                changePercentLabel.textColor = .systemRed
                changePercentLabel.layer.backgroundColor = UIColor.clear.cgColor
            case .positive:
                changePercentLabel.textColor = .systemGreen
                changePercentLabel.layer.backgroundColor = UIColor.clear.cgColor
            case .down:
                changePercentLabel.textColor = .white
                changePercentLabel.layer.backgroundColor = UIColor.systemRed.cgColor
            case .up:
                changePercentLabel.textColor = .white
                changePercentLabel.layer.backgroundColor = UIColor.systemGreen.cgColor
            }
        }
        
        if let latestPrice = item.quote.ltp, let latestPriceChange = item.quote.chg {
            priceLabel.text = "\(latestPrice.withFormat) (\(latestPriceChange.withFormatPlusSign))"
        }
    }
}


