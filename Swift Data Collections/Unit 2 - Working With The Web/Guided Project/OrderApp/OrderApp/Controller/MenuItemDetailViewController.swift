//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by Quien on 2023/1/10.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var priceLabel: UILabel!
  @IBOutlet var detailTextLabel: UILabel!
  @IBOutlet var addToOrderButton: UIButton!
  
  let menuItem: MenuItem
  
  init?(coder: NSCoder, menuItem: MenuItem) {
    self.menuItem = menuItem
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    MenuController.shared.updateUserActivity(with: .menuItemDetail(menuItem))
  }
  
  func updateUI() {
    nameLabel.text = menuItem.name
    priceLabel.text = menuItem.price.formatted(.currency(code: "usd"))
    detailTextLabel.text = menuItem.detailText
    
    Task {
      if let image = try? await MenuController.shared.fetchImage(from: menuItem.imageURL) {
        imageView.image = image
      }
    }
  }
  
  // MARK: - Action
  
  @IBAction func orderButtonTapped(_ sender: Any) {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: [], animations: {
      self.addToOrderButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
      self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }, completion: nil)
    
    MenuController.shared.order.menuItems.append(menuItem)
  }
  
}
