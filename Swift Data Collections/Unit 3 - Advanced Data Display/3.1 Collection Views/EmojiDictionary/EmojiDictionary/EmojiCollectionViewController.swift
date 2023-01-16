//
//  EmojiCollectionViewController.swift
//  EmojiDictionary
//
//  Created by Quien on 2023/1/15.
//

import UIKit

private let reuseIdentifier = "EmojiItemCell"

class EmojiCollectionViewController: UICollectionViewController {
  
  var emojis: [Emoji] = Emoji.loadSampleEmojis()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70)), subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    
    collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
  }
  
  // MARK: - UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 0 {
      return emojis.count
    } else {
      return 0
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EmojiCollectionViewCell
    
    //Step 2: Fetch model object to display
    let emoji = emojis[indexPath.item]
    //Step 3: Configure cell
    cell.update(with: emoji)
    //Step 4: Return cell
    return cell
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
    emojis.remove(at: indexPath.row)
    collectionView.deleteItems(at: [indexPath])
  }
  
  // MARK: - Navigation
  
  @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
    if let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
      // Editing Emoji
      let emojiToEdit = emojis[indexPath.row]
      return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
    } else {
      // Adding Emoji
      return AddEditEmojiTableViewController(coder: coder, emoji: nil)
    }
  }
  
  @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
    guard segue.identifier == "saveUnwind",
          let sourceViewController = segue.source as? AddEditEmojiTableViewController,
          let emoji = sourceViewController.emoji else { return }
    
    if let path = collectionView.indexPathsForSelectedItems?.first {
      emojis[path.row] = emoji
      collectionView.reloadItems(at: [path])
    } else {
      let newIndexPath = IndexPath(row: emojis.count, section: 0)
      emojis.append(emoji)
      collectionView.insertItems(at: [newIndexPath])
    }
  }
  
}
