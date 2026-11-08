//
//  ContentsTableViewCell.swift
//  GitHubSearchUIKit
//
//  Created by mickey-wp on 2026/11/07
//
//

import UIKit

class ContentsTableViewCell: BaseTableViewCell {
    
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starCountLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var imageTask: URLSessionDataTask?
    private var loadingURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        
        setupCardLayout()
        setupIconLayout()
    }
    
    private func setupCardLayout() {
        cardView.layer.cornerRadius = 20
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.systemGray.cgColor
        cardView.clipsToBounds = true
    }
    
    private func setupIconLayout() {
        iconImageView.layer.cornerRadius = 30
        iconImageView.clipsToBounds = true
        iconImageView.layer.borderWidth = 2
        iconImageView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageTask?.cancel()
        imageTask = nil
        loadingURL = nil
        iconImageView.image = nil
    }
    
    func update(_ model: ContentsCellViewModel) {
        titleLabel.text = model.detail.title
        languageLabel.text = model.detail.language ?? ""
        starCountLabel.text = String(model.detail.star)
        descriptionLabel.text = model.detail.description ?? ""
        loadIcon(from: model.detail.iconImageUrl)
    }

    private func loadIcon(from url: URL?) {
        imageTask?.cancel()
        loadingURL = url
        guard let url else {
            return
        }
        
        imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                guard self?.loadingURL == url else {
                    return
                }
                self?.iconImageView.image = image
            }
        }
        imageTask?.resume()
    }
}
