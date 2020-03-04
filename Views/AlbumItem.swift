//
//  AlbumItem.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 14/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import UIKit

class AlbumItem: UICollectionViewCell {

    var apiClient = APIClient()

    var artist: Artist? {
        didSet {
            subtitleLabel.text = artist?.name
        }
    }

    var album: Album? {
        didSet {
            titleLabel.text = album?.title

            apiClient.getImage(url: album!.cover) { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    lazy var titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        addSubview(label)
        return label
    }()

    lazy var subtitleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        addSubview(label)
        return label
    }()

    lazy var imageView: UIImageView = {
        var iv = UIImageView(image: UIImage(named: "PlaceholderImage")?.withTintColor(.gray, renderingMode: .automatic))
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        addSubview(iv)
        return iv
    }()

    lazy var specialHighlightedArea: UIView = {
        var v = UIView(frame: .zero)
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        addSubview(v)
        return v
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.size.width - 40)/2),
            imageView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.size.width - 40)/2),
        ])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            subtitleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            specialHighlightedArea.topAnchor.constraint(equalTo: topAnchor),
            specialHighlightedArea.trailingAnchor.constraint(equalTo: trailingAnchor),
            specialHighlightedArea.leadingAnchor.constraint(equalTo: leadingAnchor),
            specialHighlightedArea.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        willSet {
            onSelected(newValue)
        }
    }

    func onSelected(_ newValue: Bool) {
        guard selectedBackgroundView == nil else { return }
        specialHighlightedArea.backgroundColor = newValue ? UIColor.systemFill : UIColor.clear
    }
}
