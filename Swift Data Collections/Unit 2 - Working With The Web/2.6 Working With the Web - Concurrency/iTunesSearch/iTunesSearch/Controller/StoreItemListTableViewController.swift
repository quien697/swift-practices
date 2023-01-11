//
//  StoreItemListTableViewController.swift
//  iTunesSearch
//
//  Created by Quien on 2023/1/10.
//

import UIKit

class StoreItemListTableViewController: UITableViewController {
  
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var filterSegmentedControl: UISegmentedControl!
  
  // add item controller property
  var storeItemController = StoreItemController()
  var items = [StoreItem]()
  let queryOptions = ["movie", "music", "software", "ebook"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func fetchMatchingItems() {
    self.items = []
    self.tableView.reloadData()
    let searchTerm = searchBar.text ?? ""
    let mediaType = queryOptions[filterSegmentedControl.selectedSegmentIndex]
    
    if !searchTerm.isEmpty {
      // set up query dictionary
      let query: [String: String] = [
        "term": searchTerm,
        "media": mediaType,
        "limit": "20",
        "lang": "en_us",
      ]
      
      // use the item controller to fetch items
      // if successful, use the main queue to set self.items and reload the table view
      // otherwise, print an error to the console
      Task {
        do {
          let storeItems = try await storeItemController.fetchItems(matching: query)
          items = storeItems
          self.tableView.reloadData()
          print(storeItems)
        } catch {
          print("storeItemsError: \(error)")
        }
      }
    }
  }
  
  // MARK: - Action
  
  @IBAction func filterSegmentedControlChanged(_ sender: UISegmentedControl) {
    fetchMatchingItems()
  }
  
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "storeItemCell", for: indexPath) as! StoreItemTableViewCell
    configure(cell: cell, forItemAt: indexPath)
    return cell
  }
  
  func configure(cell: StoreItemTableViewCell, forItemAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    // set cell.titleLabel to the item's name
    cell.titleLabel.text = item.name
    // set cell.detailLabel to the item's artist
    cell.detailLabel.text = item.artist
    // set cell.itemImageView to the system image "photo"
    cell.itemImageView.image = UIImage(systemName: "photo.on.rectangle")
    // initialize a network task to fetch the item's artwork
    // if successful, use the main queue capture the cell, to initialize a UIImage, and set the cell's image view's image to the
    Task {
      do {
        let image = try await storeItemController.fetchImage(from: item.artworkURL)
        cell.itemImageView.image = image
      } catch {
        print("imageError: \(error)")
      }
    }
  }
  
  // MARK: - Table view delegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

}

extension StoreItemListTableViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    fetchMatchingItems()
    searchBar.resignFirstResponder()
  }
}
