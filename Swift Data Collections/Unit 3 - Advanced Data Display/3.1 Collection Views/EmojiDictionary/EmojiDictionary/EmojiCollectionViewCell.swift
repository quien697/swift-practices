//
//  EmojiCollectionViewCell.swift
//  EmojiDictionary
//
//  Created by Quien on 2023/1/15.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet var symbolLabel: UILabel!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  
  func update(with emoji: Emoji) {
      symbolLabel.text = emoji.symbol
      nameLabel.text = emoji.name
      descriptionLabel.text = emoji.description
  }
  
}
