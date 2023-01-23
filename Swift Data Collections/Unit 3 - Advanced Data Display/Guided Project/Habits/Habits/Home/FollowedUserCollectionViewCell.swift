//
//  FollowedUserCollectionViewCell.swift
//  Habits
//
//  Created by Quien on 2023/1/22.
//

import UIKit

class FollowedUserCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var primaryTextLabel: UILabel!
  @IBOutlet weak var secondaryTextLabel: UILabel!
  @IBOutlet weak var separatorLineView: UIView!
  @IBOutlet weak var separatorLineHeightConstraint: NSLayoutConstraint!

  override func awakeFromNib() {
    separatorLineHeightConstraint.constant = 1 / UITraitCollection.current.displayScale
  }
}
