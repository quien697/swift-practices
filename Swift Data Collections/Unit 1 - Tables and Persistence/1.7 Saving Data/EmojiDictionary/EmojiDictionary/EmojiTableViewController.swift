//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Quien on 2022/11/23.
//

import UIKit

class EmojiTableViewController: UITableViewController {
  
  var emojis = [Emoji]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = editButtonItem
    // dynamic tableview's cell's height
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44.0
    
    if let savedEmojis = Emoji.loadFromFile() {
      emojis = savedEmojis
    } else {
      emojis = Emoji.loadSampleEmojis()
    }
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    emojis.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! EmojiTableViewCell
    let emoji = emojis[indexPath.row]
    cell.update(with: emoji)
    return cell
  }
  
  // MARK: - Table view delegate
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let movedEmoji = emojis.remove(at: sourceIndexPath.row)
    emojis.insert(movedEmoji, at: destinationIndexPath.row)
    Emoji.saveToFile(emojis: emojis)
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      emojis.remove(at: indexPath.row)
      Emoji.saveToFile(emojis: emojis)
      tableView.deleteRows(at: [indexPath], with: . automatic)
    }
  }
  
  // MARK: - Navigation
  
  @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
    if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
      // Editing Emoji
      let emojiToEdit = emojis[indexPath.row]
      return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
    } else {
      // Adding Emoji
      return AddEditEmojiTableViewController(coder: coder, emoji: nil)
    }
  }
  
  @IBAction func unwindToEmojiTableViewController(segue: UIStoryboardSegue) {
    guard segue.identifier == "saveUnwind", let sourceViewController = segue.source as? AddEditEmojiTableViewController, let emoji = sourceViewController.emoji else { return }
    
    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      // edit
      emojis[selectedIndexPath.row] = emoji
      tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
    } else {
      // add
      emojis.append(emoji)
      tableView.insertRows(at: [IndexPath(row: emojis.count-1, section: 0)], with: .automatic)
    }
    Emoji.saveToFile(emojis: emojis)
  }
  
}
