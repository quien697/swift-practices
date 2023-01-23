//
//  HabitCollectionViewController.swift
//  Habits
//
//  Created by Quien on 2023/1/20.
//

import UIKit

private let reuseIdentifier = "Habit"
let favoriteHabitColor = UIColor(hue: 0.15, saturation: 1, brightness: 0.9, alpha: 1)

class HabitCollectionViewController: UICollectionViewController {
  
  typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
  
  enum ViewModel {
    enum Section: Hashable, Comparable {
      case favorites
      case category(_ category: Category)
      
      static func < (lhs: HabitCollectionViewController.ViewModel.Section, rhs: HabitCollectionViewController.ViewModel.Section) -> Bool {
        switch (lhs, rhs) {
        case (.category (let l), .category(let r)):
          return l.name < r.name
        case (.favorites, _):
          return true
        case (_, .favorites):
          return false
        }
      }
      
      var sectionColor: UIColor {
        switch self {
        case .favorites:
          return favoriteHabitColor
        case .category(let category):
          return category.color.uiColor
        }
      }
      
    }
    
    typealias Item = Habit
  }
  
  struct Model {
    var habitsByName = [String: Habit]()
    var favoriteHabits: [Habit] {
      return Settings.shared.favoriteHabits
    }
  }
  
  var dataSource: DataSourceType!
  var model = Model()
  
  // Keep track of async tasks so they can be cancelled when appropriate
  var habitResqestTask: Task<Void, Never>? = nil
  deinit { habitResqestTask?.cancel() }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataSource = createDataSource()
    collectionView.dataSource = dataSource
    collectionView.collectionViewLayout = createLayout()
    collectionView.register(
      NamedSectionHeaderView.self,
      forSupplementaryViewOfKind: SectionHeader.kind.identifier,
      withReuseIdentifier: SectionHeader.reuse.identifier)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    update()
  }
  
  // MARK: - Update UI
  
  func update() {
    habitResqestTask?.cancel()
    habitResqestTask = Task {
      if let habits = try? await HabitRequest().send() {
        self.model.habitsByName = habits
      } else {
        self.model.habitsByName = [:]
      }
      self.updateCollectionView()
    }
    habitResqestTask = nil
  }
  
  func updateCollectionView() {
    var itemsBySection = model.habitsByName.values.reduce(into: [ViewModel.Section: [ViewModel.Item]]()) { (partial, habit) in
      let item = habit
      let section: ViewModel.Section
      if model.favoriteHabits.contains(habit) {
        section = .favorites
      } else {
        section = .category(habit.category)
      }
      partial[section, default: []].append(item)
    }
    
    itemsBySection = itemsBySection.mapValues({ $0.sorted() })
    let sectionIDs = itemsBySection.keys.sorted()
    
    dataSource.applySnapshotUsing(sectionIDs: sectionIDs, itemsBySection: itemsBySection)
  }
  
  // MARK: - UICollectionViewDataSource
  
  func createDataSource() -> DataSourceType {
    // Cell
    let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, item in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Habit", for: indexPath) as! UICollectionViewListCell
      
      self.configureCell(cell, withItem: item)
      return cell
    }
    // Header
    dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
      let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: SectionHeader.kind.identifier,
        withReuseIdentifier: SectionHeader.reuse.identifier,
        for: indexPath) as! NamedSectionHeaderView
      let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
      header.backgroundColor = section.sectionColor
      switch section {
      case .favorites:
        header.nameLabel.text = "Favorites"
      case .category(let category):
        header.nameLabel.text = category.name
      }
      return header
    }
    return dataSource
  }
  
  func configureCell(_ cell: UICollectionViewListCell, withItem item:ViewModel.Item) {
      var content = cell.defaultContentConfiguration()
      content.text = item.name
      cell.contentConfiguration = content
  }
  
  // MARK: - UICollectionView Layout
  
  func createLayout() -> UICollectionViewCompositionalLayout {
    let spacing = CGFloat(10)
    // Item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    // Group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(44)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    // Section Header
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .absolute(36)
    )
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: SectionHeader.kind.identifier,
      alignment: .top
    )
    sectionHeader.pinToVisibleBounds = true
    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
    section.boundarySupplementaryItems = [sectionHeader]
    // Layout
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
  
  // MARK: - UICollectionViewDelegate
  
  override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
    let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
      let item = self.dataSource.itemIdentifier(for: indexPaths.first!)!
      let favoriteToggle = UIAction(title: self.model.favoriteHabits.contains(item) ? "Unfavorite" : "Favorite") { (action) in
        Settings.shared.toggleFavorite(item)
        self.updateCollectionView()
      }
      return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [favoriteToggle])
    }
    return config
  }
  
  // MARK: - Segue
  
  @IBSegueAction func showHabitDetail(_ coder: NSCoder, sender: UICollectionViewCell?) -> HabitDetailViewController? {
    guard let cell = sender,
          let indexPath = collectionView.indexPath(for: cell),
          let item = dataSource.itemIdentifier(for: indexPath) else {
      return nil
    }
    return HabitDetailViewController(coder: coder, habit: item)
  }
  
}
