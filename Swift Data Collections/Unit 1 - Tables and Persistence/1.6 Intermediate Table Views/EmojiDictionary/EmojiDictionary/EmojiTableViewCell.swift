//
//  EmojiTableViewCell.swift
//  EmojiDictionary
//
//  Created by Quien on 2022/11/27.
//

import UIKit

class EmojiTableViewCell: UITableViewCell {

  @IBOutlet weak var SymbolLabel: UILabel!
  @IBOutlet weak var NameLabel: UILabel!
  @IBOutlet weak var DescriptionLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    showsReorderControl = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func update(with emoji: Emoji) {
    SymbolLabel.text = emoji.symbol
    NameLabel.text = emoji.name
    DescriptionLabel.text = emoji.description
  }

}
