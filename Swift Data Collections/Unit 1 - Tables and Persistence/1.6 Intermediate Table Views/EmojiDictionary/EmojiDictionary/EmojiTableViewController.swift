//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Quien on 2022/11/23.
//

import UIKit

class EmojiTableViewController: UITableViewController {
  
  var emojis: [Emoji] = [
    Emoji(symbol: "π", name: "Grinning Face", description: "A typical smiley face.", usage: "happiness"),
    Emoji(symbol: "π", name: "Confused Face", description: "A confused, puzzled face.", usage: "unsure what to think; displeasure"),
    Emoji(symbol: "π", name: "Heart Eyes",
          description: "A smiley face with hearts for eyes.", usage: "love of something; attractive"),
    Emoji(symbol: "π§βπ»", name: "Developer", description: "A person working on a MacBook (probably using Xcode to write iOS apps in Swift).", usage: "apps, software, programming"),
    Emoji(symbol: "π’", name: "Turtle", description: "A cute turtle.", usage: "something slow"),
    Emoji(symbol: "π", name: "Elephant", description: "A gray elephant.", usage: "good memory"),
    Emoji(symbol: "π", name: "Spaghetti", description: "A plate of spaghetti.", usage: "spaghetti"),
    Emoji(symbol: "π²", name: "Die", description: "A single die.", usage: "taking a risk, chance; game"),
    Emoji(symbol: "βΊοΈ", name: "Tent", description: "A small tent.", usage: "camping"),
    Emoji(symbol: "π", name: "Stack of Books",
          description: "Three colored books stacked on each other.", usage: "homework, studying"),
    Emoji(symbol: "π", name: "Broken Heart",
          description: "A red, broken heart.", usage: "extreme sadness"), Emoji(symbol: "π€", name: "Snore",
                                                                                description: "Three blue \'z\'s.", usage: "tired, sleepiness"),
    Emoji(symbol: "π", name: "Checkered Flag", description: "A black-and-white checkered flag.", usage: "completion")
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = editButtonItem
    // dynamic tableview's cell's height
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44.0
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
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      emojis.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: . automatic)
    }
  }
  
  // MARK: - Navigation
  
  @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
    if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
      let emojiToEdit = emojis[indexPath.row]
      return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
    } else {
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
  }
  
}
