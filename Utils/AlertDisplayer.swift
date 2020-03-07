//
//  AlertDisplayer.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 07/03/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import UIKit

protocol AlertDisplayer {
    func displayGenericError()
}

extension AlertDisplayer where Self: UIViewController {
    func displayGenericError() {
        DispatchQueue.main.async {
            let title = "Something went wrong"
            let message = "Something went wrong, try again later"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true)
            SpinnerView.shared.hideProgressView()
        }
    }
}
