//
//  CollectionViewCell.swift
//  iTunesSearch
//
//  Created by Quien on 2023/1/16.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell, ItemDisplaying {  
  @IBOutlet var itemImageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var detailLabel: UILabel!
}
