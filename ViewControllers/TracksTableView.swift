//
//  TracksTableView.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 16/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import UIKit

class TracksTableView: UIViewController {

    private let album: Album
    private let tracks: [TrackDetail]
    private let coverImage: UIImage


    init(album: Album, coverImage: UIImage) {
        self.album = album
        self.coverImage = coverImage
        self.tracks = album.tracks!
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var tableView: UITableView = {
        var tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(TrackCell.self, forCellReuseIdentifier: TrackCell.getReuseId())
        tv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tv)
        return tv
    }()

    private lazy var imageContainer: UIView = {
        var container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        var iv = UIImageView(image: coverImage)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit

        iv.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        iv.heightAnchor.constraint(equalToConstant: view.bounds.width).isActive = true

        container.addSubview(iv)

        iv.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        iv.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        iv.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        iv.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true

        return container
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        tableView.setTableHeaderView(header: imageContainer)

        title = album.title
        view.backgroundColor = .systemBackground
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

    private func formatDuration(duration: Int) -> String {
        let duration = TimeInterval(duration) // 2 minutes, 30 seconds

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]

        return formatter.string(from: duration)!
    }
}

extension TracksTableView: UITableViewDelegate, UITableViewDataSource {


    func numberOfSections(in tableView: UITableView) -> Int {
        return tracks.map {$0.disk_number}.max() ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.filter( {$0.disk_number == section+1} ).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.getReuseId(), for: indexPath) as! TrackCell
        let sectionTracks = tracks.filter( {$0.disk_number == indexPath.section+1} )

        cell.trackTitle.text = sectionTracks[indexPath.row].title
        cell.artistLabel.text = sectionTracks[indexPath.row].contributors.map({$0.name}).joined(separator: ", ")
        cell.indexLabel.text = "\(sectionTracks[indexPath.row].track_position)."
        cell.duration.text = formatDuration(duration: sectionTracks[indexPath.row].duration)

        cell.layoutIfNeeded()
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(NSLocalizedString("VOLUME_NUMBER_OF_PLATES", comment: "Number of plates prefix")) \(section+1)"
    }

}


// Header/Footer views requires an explicit height to even be presented above/beneath the tableView.
// Here are two helper functions that can be used when setting Header/Footer for a tableView.
extension UITableView {

    func setTableHeaderView(header: UIView) {
        setFrame(of: header)
        tableHeaderView = header
    }

    func setTableFooterView(footer: UIView) {
        setFrame(of: footer)
        tableFooterView = footer
    }

    private func setFrame(of view: UIView) {
        // Make sure the tableView has the correct frame before proceeding.
        //layoutIfNeeded()

        view.translatesAutoresizingMaskIntoConstraints = false
        let widthAnchor = view.widthAnchor.constraint(equalToConstant: bounds.width)
        widthAnchor.isActive = true

        view.setNeedsLayout()
        view.layoutIfNeeded()
        let height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        view.frame = CGRect(
            origin: .zero,
            size: CGSize(width: bounds.width, height: height)
        )

        widthAnchor.isActive = false
        view.translatesAutoresizingMaskIntoConstraints = true
    }
}
