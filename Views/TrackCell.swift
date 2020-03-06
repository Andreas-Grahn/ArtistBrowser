//
//  TrackCell.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 19/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {

    var trackDetail: TrackDetail? {
        didSet { DispatchQueue.main.async {
            if let details = self.trackDetail {
                self.indexLabel.text = "\(details.track_position)."
                self.name.text = details.title
                var artists = ""
                for artist in details.contributors {
                    artists += "\(artist.name), "

                }

                self.artistLabel.text = details.contributors.map({$0.name}).joined(separator: ", ")
                self.duration.text = self.formatDuration(duration: details.duration)
            }
            }
        }
    }

    func formatDuration(duration: Int) -> String {
        let duration = TimeInterval(duration) // 2 minutes, 30 seconds

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]

        return formatter.string(from: duration)!
    }

    lazy var indexLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "-"
        label.widthAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    }()

    lazy var name: UILabel = {
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
        addSubview(label)
        return label
    }()

    lazy var stackView: UIStackView = {
        let sv = UIStackView(frame: .zero)
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .leading

        sv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sv)


        sv.spacing = 6

        sv.addArrangedSubview(name)
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

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            indexLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            indexLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: duration.leadingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            duration.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            duration.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
