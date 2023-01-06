//
//  ViewController.swift
//  NavBarAnimation
//
//  Created by Quien on 2023/1/4.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var navBarView: UIView!
  @IBOutlet weak var titleCenterYConstraint: NSLayoutConstraint!
  @IBOutlet weak var navBarHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  let oreos = Snack(id: 1, title: "Oreos", imgName: "oreos")
  let pizzaPockets = Snack(id: 2, title: "Pizza Pockets", imgName: "pizza_pockets")
  let popTarts = Snack(id: 3, title: "Pop Tarts", imgName: "pop_tarts")
  let popsicle = Snack(id: 4, title: "Popsicle", imgName: "popsicle")
  let ramen = Snack(id: 5, title: "Ramen", imgName: "ramen")
  
  var stackView = UIStackView()
  var isTapped: Bool = false
  var snacks: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    makeSnackView()
  }
  
  //MARK: - View
  
  func makeSnackView() {
    let oreosImage = snackImageView(snack: oreos)
    let pizzaPocketsImage = snackImageView(snack: pizzaPockets)
    let popTartsImage = snackImageView(snack: popTarts)
    let popsicleImage = snackImageView(snack: popsicle)
    let ramenImage = snackImageView(snack: ramen)
    
    stackView.addArrangedSubviews([oreosImage, pizzaPocketsImage, popTartsImage, popsicleImage, ramenImage])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    
    view.addSubview(stackView)
    
    stackView.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: -10).isActive = true
    stackView.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor, constant: 10).isActive = true
    stackView.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor, constant: -10).isActive = true
    stackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    stackView.isHidden = true
  }
  
  func snackImageView(snack: Snack) -> UIImageView {
    let imageView = UIImageView(image: UIImage(named: snack.imgName))
    imageView.tag = snack.id
    let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.snackImageTapped(_:)))
    imageView.addGestureRecognizer(tapGR)
    imageView.isUserInteractionEnabled = true
    return imageView
  }
  
  // MARK: - Action
  
  @IBAction func addButtonTapped(_ sender: UIButton) {
    isTapped.toggle()
    if isTapped {
      stackView.isHidden = false
      self.navBarHeightConstraint.constant = 250
      self.titleCenterYConstraint.constant = -23
      titleLabel.text = "Add a SNACK"
      UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5.0) {
        self.view.layoutIfNeeded()
        self.addButton.transform = CGAffineTransform(rotationAngle: .pi/4 )
      }
    } else {
      stackView.isHidden = true
      self.navBarHeightConstraint.constant = 98
      self.titleCenterYConstraint.constant = 23
      titleLabel.text = "SNACKS"
      UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 2.0) {
        self.view.layoutIfNeeded()
        self.addButton.transform = .identity
      }
    }
  }
  
  @objc func snackImageTapped(_ sender: UITapGestureRecognizer) {
    let indexPath = IndexPath(row: snacks.count, section: 0)
    switch sender.view?.tag {
    case oreos.id:
      snacks.append(oreos.title)
    case pizzaPockets.id:
      snacks.append(pizzaPockets.title)
    case popTarts.id:
      snacks.append(popTarts.title)
    case popsicle.id:
      snacks.append(popsicle.title)
    case ramen.id:
      snacks.append(ramen.title)
    default:
      print("default")
    }
    tableView.insertRows(at: [indexPath], with: .fade)
  }
  
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return snacks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "snackCell", for: indexPath)
    cell.textLabel!.text = snacks[indexPath.row]
    return cell
  }
}

extension UIStackView {
  func addArrangedSubviews(_ views: [UIView]) {
    views.forEach{ self.addArrangedSubview($0) }
  }
}
