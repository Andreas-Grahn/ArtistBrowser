//
//  SpinnerView.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 24/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import UIKit

class SpinnerView {
    public static let shared = SpinnerView()

    private var backgroundView = UIView()
    private var contentView = UIView()
    private var activityIndicator = UIActivityIndicatorView()

    open func showProgressView() {
        let window = UIWindow(frame: UIScreen.main.bounds)

        backgroundView.frame = window.frame
        backgroundView.center = window.center
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.7)

        contentView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        contentView.center = window.center
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10

        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .large
        activityIndicator.center = CGPoint(x: contentView.bounds.width / 2, y: contentView.bounds.height / 2)

        contentView.addSubview(activityIndicator)
        backgroundView.addSubview(contentView)
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(backgroundView)

        activityIndicator.startAnimating()
    }

    open func hideProgressView() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.backgroundView.removeFromSuperview()
        }
    }
}
