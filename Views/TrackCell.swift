//
//  TrackCell.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 19/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {

    lazy var indexLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "-"
        label.widthAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    lazy var trackTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.text = "-"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var artistLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.text = "-"
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var duration: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "-"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    lazy var stackView: UIStackView = {
        let sv = UIStackView(frame: .zero)
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .leading

        sv.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sv)

        sv.spacing = 6
        sv.addArrangedSubview(trackTitle)
        sv.addArrangedSubview(artistLabel)
        return sv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //Makes sure that trackTitle wraps text properly
    override func layoutSubviews() {
        contentView.layoutIfNeeded()
        trackTitle.preferredMaxLayoutWidth = stackView.frame.width
        super.layoutSubviews()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            indexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            indexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.trailingAnchor.constraint(equalTo: duration.leadingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            duration.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            duration.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
