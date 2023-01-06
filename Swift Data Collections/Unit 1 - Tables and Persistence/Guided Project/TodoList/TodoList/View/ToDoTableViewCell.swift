//
//  ToDoTableViewCell.swift
//  TodoList
//
//  Created by Quien on 2022/12/1.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
  
  @IBOutlet weak var isCompleteButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  
  var dekegate: ToDoCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  @IBAction func completeButtonTapped(_ sender: UIButton) {
    dekegate?.checkmarkTapped(sender: self)
  }
  
}

protocol ToDoCellDelegate: AnyObject {
  func checkmarkTapped(sender: ToDoTableViewCell)
}
