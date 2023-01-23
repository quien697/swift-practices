//
//  UserCollectionViewController.swift
//  Habits
//
//  Created by Quien on 2023/1/20.
//

import UIKit

private let reuseIdentifier = "Cell"

class UserCollectionViewController: UICollectionViewController {
  
  typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
  
  enum ViewModel {
    typealias Section = Int
    
    struct Item: Hashable {
      let user: User
      let isFollowed: Bool
      
      func hash(into hasher: inout Hasher) {
        hasher.combine(user)
      }
      
      static func ==(_ lhs: Item, _ rhs: Item) -> Bool {
        return lhs.user == rhs.user
      }
    }
  }
  
  struct Model {
    var usersByID = [String:User]()
    var followedUsers: [User] {
      return Array(usersByID.filter
                   { Settings.shared.followedUserIDs.contains($0.key)
      }.values)
    }
  }
  
  var dataSource: DataSourceType!
  var model = Model()
  
  // Keep track of async tasks so they can be cancelled when appropriate
  var usersRequestTask: Task<Void, Never>? = nil
  deinit { usersRequestTask?.cancel() }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = createDataSource()
    collectionView.dataSource = dataSource
    collectionView.collectionViewLayout = createLayout()
    update()
  }
  
  // MARK: - Update UI
  
  func update() {
    usersRequestTask?.cancel()
    usersRequestTask = Task {
      if let users = try? await UserRequest().send() {
        self.model.usersByID = users
      } else {
        self.model.usersByID = [:]
      }
      self.updateCollectionView()
      usersRequestTask = nil
    }
  }
  
  func updateCollectionView() {
    let users = model.usersByID.values.sorted().reduce(into: [ViewModel.Item]()) { partial, user in
      partial.append(ViewModel.Item(user: user, isFollowed: model.followedUsers.contains(user)))
    }
    let itemsBySection = [0: users]
    dataSource.applySnapshotUsing(sectionIDs: [0], itemsBySection: itemsBySection)
  }
  
  // MARK: - UICollectionViewDataSource
  
  func createDataSource() -> DataSourceType {
    let dataSource = DataSourceType(collectionView: collectionView)
    { (collectionView, indexPath, item) in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "User", for: indexPath) as! UICollectionViewListCell
      
      var content = cell.defaultContentConfiguration()
      content.text = item.user.name
      content.directionalLayoutMargins =
      NSDirectionalEdgeInsets(top: 11, leading: 8, bottom: 11, trailing: 8)
      content.textProperties.alignment = .center
      cell.contentConfiguration = content
      var backgroundConfiguration = UIBackgroundConfiguration.clear()
      backgroundConfiguration.backgroundColor = item.user.color?.uiColor ?? UIColor.systemGray4
      backgroundConfiguration.cornerRadius = 8
      cell.backgroundConfiguration = backgroundConfiguration
      return cell
    }
    return dataSource
  }
  
  // MARK: - UICollectionView Layout
  
  func createLayout() -> UICollectionViewCompositionalLayout {
    let spacing = CGFloat(20)
    // Item
    let itemSize =
    NSCollectionLayoutSize(
      widthDimension: .fractionalHeight(1),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    // Group
    let groupSize =
    NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(0.45))
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item])
    group.interItemSpacing = .fixed(spacing)
    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = spacing
    section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
    // Layout
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
  
  // MARK: - UICollectionViewDelegate
  
  override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
    let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (elements) -> UIMenu? in
      guard let item = self.dataSource.itemIdentifier(for: indexPaths.first!) else { return nil }
      
      let favoriteToggle = UIAction(title: item.isFollowed ? "Unfollow" : "Follow") { (action) in
        Settings.shared.toggleFollowed(user: item.user)
        self.updateCollectionView()
      }
      return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [favoriteToggle])
    }
    return config
  }
  
  // MARK: - Segue
  
  @IBSegueAction func showUserDetail(_ coder: NSCoder, sender: UICollectionViewCell?) -> UserDetailViewController? {
    guard let cell = sender,
          let indexPath = collectionView.indexPath(for: cell),
          let item = dataSource.itemIdentifier(for: indexPath) else {
      return nil
    }
    
    return UserDetailViewController(coder: coder, user: item.user)
  }
}
