//
//  ItemDisplaying.swift
//  iTunesSearch
//
//  Created by Quien on 2023/1/17.
//

import UIKit

protocol ItemDisplaying {
  var itemImageView: UIImageView! { get set }
  var titleLabel: UILabel! { get set }
  var detailLabel: UILabel! { get set }
}

@MainActor
extension ItemDisplaying {
  func configure(for item: StoreItem, storeItemController: StoreItemController) async {
    titleLabel.text = item.name
    detailLabel.text = item.artist
    itemImageView.image = UIImage(systemName: "photo")
    do {
      let image = try await storeItemController.fetchImage(from: item.artworkURL)
      itemImageView.image = image
    } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
      // Ignore cancellation errors
    } catch {
      itemImageView.image = UIImage(systemName: "photo")
      print("Error fetching image: \(error)")
    }
  }
}
