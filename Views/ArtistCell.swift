//
//  ArtistCell.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 19/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import UIKit

class ArtistCell: UITableViewCell {

    func setImage(image: UIImage) {
        DispatchQueue.main.async {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
            self.artistImage.image = renderer.image { (context) in
                image.draw(in: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
            }
        }
    }

    lazy var artistImage: UIImageView = {
        let iv = UIImageView()

        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iv)
        return iv
    }()

    lazy var artistLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        selectionStyle = .default
        setupConstraint()
        if let image = UIImage(named: "PlaceholderImage")?.withTintColor(.gray, renderingMode: .automatic) {
            setImage(image: image)
        }


    }

    func setupConstraint() {
        NSLayoutConstraint.activate([
            artistImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            artistImage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            artistLabel.leadingAnchor.constraint(equalTo: artistImage.trailingAnchor, constant: 10),
            artistLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),
            artistLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
