//
//  EmojiCollectionViewController.swift
//  EmojiDictionary
//
//  Created by Quien on 2023/1/15.
//

import UIKit

private let reuseIdentifier = "ItemCell"
private let columnReuseIdentifier = "ColumnItemCell"
private let headerIdentifier = "Header"
private let headerKind = "header"

class EmojiCollectionViewController: UICollectionViewController {
  
  @IBOutlet weak var layoutButton: UIBarButtonItem!
  
  var emojis: [Emoji] = Emoji.loadSampleEmojis()
  var sections: [Section] = []
  var layout: [Layout: UICollectionViewLayout] = [:]
  
  var activeLayout: Layout = .grid {
    didSet {
      if let layout = layout[activeLayout] {
        self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
        collectionView.setCollectionViewLayout(layout, animated: true) { (_) in
          switch self.activeLayout {
          case .grid:
            self.layoutButton.image = UIImage(systemName: "rectangle.grid.1x2")
          case .column:
            self.layoutButton.image = UIImage(systemName: "square.grid.2x2")
          }
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.register(EmojiCollectionViewHeader.self, forSupplementaryViewOfKind: headerKind, withReuseIdentifier: headerIdentifier)
    
    layout[.grid] = generateGridLayout()
    layout[.column] = generateColumnLayout()
    
    if let layout = layout[activeLayout] {
      collectionView.collectionViewLayout = layout
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateSections()
    collectionView.reloadData()
  }
  
  func generateGridLayout() -> UICollectionViewLayout {
    let padding: CGFloat = 10
    let item = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.5),
        heightDimension: .fractionalHeight(1)
      )
    )
    item.contentInsets = NSDirectionalEdgeInsets(
      top: padding,
      leading: padding,
      bottom: padding,
      trailing: padding
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1/4)
      ),
      subitems: [item, item]
    )
    group.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: padding,
      bottom: 0,
      trailing: padding
    )
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = padding
    section.contentInsets = NSDirectionalEdgeInsets(
      top: padding,
      leading: 0,
      bottom: padding,
      trailing: 0
    )
    section.boundarySupplementaryItems = [generateHeader()]
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  func generateColumnLayout() -> UICollectionViewLayout {
    let padding: CGFloat = 10
    let item = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
      )
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .absolute(120)
      ),
      subitems: [item]
    )
    group.interItemSpacing = .fixed(padding)
    group.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: padding,
      bottom: 0,
      trailing: padding
    )
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = padding
    section.contentInsets = NSDirectionalEdgeInsets(
      top: padding,
      leading: 0,
      bottom: padding,
      trailing: 0
    )
    section.boundarySupplementaryItems = [generateHeader()]
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  func generateHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(40)),
      elementKind: headerKind,
      alignment: .top
    )
    header.pinToVisibleBounds = true
    
    return header
  }
  
  func updateSections() {
    sections.removeAll()
    let grouped = Dictionary(grouping: emojis, by: { $0.sectionTitle })
    for (title, emojis) in grouped.sorted(by: { $0.0 < $1.0 }) {
      sections.append(Section(title: title, emojis: emojis.sorted(by: { $0.name < $1.name })))
    }
  }
  
  // MARK: - Action
  
  @IBAction func switchLayouts(_ sender: UIBarButtonItem) {
    switch activeLayout {
    case .grid:
        activeLayout = .column
    case .column:
        activeLayout = .grid
    }
  }
  
  
  // MARK: - UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sections.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sections[section].emojis.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let identifier = activeLayout == .grid ? reuseIdentifier : columnReuseIdentifier
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! EmojiCollectionViewCell
    
    //Step 2: Fetch model object to display
    let emoji = sections[indexPath.section].emojis[indexPath.item]
    //Step 3: Configure cell
    cell.update(with: emoji)
    //Step 4: Return cell
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! EmojiCollectionViewHeader
    header.titleLabel.text = sections[indexPath.section].title
    return header
  }
  
  // MARK: - UICollectionViewDelegate
  
  override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
    let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (elements) -> UIMenu? in
      let delete = UIAction(title: "Delete") { (action) in
        self.deleteEmoji(at: indexPaths[0])
      }
      return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [delete])
    }
    return config
  }
  
  func deleteEmoji(at indexPath: IndexPath) {
    let emoji = sections[indexPath.section].emojis[indexPath.item]
    guard let index = emojis.firstIndex(where: { $0 == emoji }) else { return }
    
    emojis.remove(at: index)
    sections[indexPath.section].emojis.remove(at: indexPath.item)
    collectionView.deleteItems(at: [indexPath])
  }
  
  // MARK: - Navigation
  
  @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
    if let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
      // Editing Emoji
      let emojiToEdit = sections[indexPath.section].emojis[indexPath.item]
      return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
    } else {
      // Adding Emoji
      return AddEditEmojiTableViewController(coder: coder, emoji: nil)
    }
  }
  
  func indexPath(for emoji: Emoji) -> IndexPath? {
    if let sectionIndex = sections.firstIndex(where: { $0.title == emoji.sectionTitle }),
       let index = sections[sectionIndex].emojis.firstIndex(where: { $0 == emoji }) {
      return IndexPath(item: index, section: sectionIndex)
    }
    return nil
  }
  
  @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
    guard segue.identifier == "saveUnwind",
          let sourceViewController = segue.source as? AddEditEmojiTableViewController,
          let emoji = sourceViewController.emoji else { return }
    
    if let path = collectionView.indexPathsForSelectedItems?.first, let i = emojis.firstIndex(where: { $0 == emoji }) {
      emojis[i] = emoji
      updateSections()
      collectionView.reloadItems(at: [path])
    } else {
      emojis.append(emoji)
      updateSections()
      if let newIndexPath = indexPath(for: emoji) {
        collectionView.insertItems(at: [newIndexPath])
      }
    }
  }
  
}

enum Layout {
  case grid
  case column
}
