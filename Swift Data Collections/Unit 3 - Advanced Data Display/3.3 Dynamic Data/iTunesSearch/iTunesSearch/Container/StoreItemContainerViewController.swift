//
//  StoreItemContainerViewController.swift
//  iTunesSearch
//
//  Created by Quien on 2023/1/16.
//

import UIKit

private let cellIdentifier = "ItemCell"

class StoreItemContainerViewController: UIViewController {
  
  @IBOutlet weak var tableContainerView: UIView!
  @IBOutlet weak var collectionContainerView: UIView!
  
  var items = [StoreItem]()
  let queryOptions = ["movie", "music", "software", "ebook"]
  let storeItemController = StoreItemController()
  let searchController = UISearchController()
  
  var tableViewImageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
  var collectionViewImageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
  
  var tableViewDataSource: UITableViewDiffableDataSource<String, StoreItem>!
  var collectionViewDataSource: UICollectionViewDiffableDataSource<String, StoreItem>!
  
  var itemsSnapshot: NSDiffableDataSourceSnapshot<String, StoreItem> {
    var snapshot = NSDiffableDataSourceSnapshot<String, StoreItem>()
    snapshot.appendSections(["Results"])
    snapshot.appendItems(items)
    return snapshot
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.searchController = searchController
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.automaticallyShowsSearchResultsController = true
    searchController.searchBar.showsScopeBar = true
    searchController.searchBar.scopeButtonTitles = ["Movies", "Music", "Apps", "Books"]
  }
  
  // MARK: - Action
  
  @IBAction func switchContainerViewSegmentedControlTapped(_ sender: UISegmentedControl) {
    tableContainerView.isHidden.toggle()
    collectionContainerView.isHidden.toggle()
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //  Get the new view controller using segue.destination.
    //  Pass the selected object to the new view controller.
    
    if let tableViewController = segue.destination as? StoreItemListTableViewController {
      configureTableViewDataSource(tableViewController.tableView)
    }
    
    if let collectionViewController = segue.destination as? StoreItemCollectionViewController {
      configureCollectionViewDataSource(collectionViewController.collectionView)
    }
  }
  
  func configureTableViewDataSource(_ tableView: UITableView) {
    tableViewDataSource = UITableViewDiffableDataSource<String, StoreItem>(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ItemTableViewCell
      self.tableViewImageLoadTasks[indexPath]?.cancel()
      self.tableViewImageLoadTasks[indexPath] = Task {
        await cell.configure(for: item, storeItemController: self.storeItemController)
        self.tableViewImageLoadTasks[indexPath] = nil
      }
      return cell
    })
  }
  
  func configureCollectionViewDataSource(_ collectionView: UICollectionView) {
    collectionViewDataSource = UICollectionViewDiffableDataSource<String, StoreItem>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ItemCollectionViewCell
      self.tableViewImageLoadTasks[indexPath]?.cancel()
      self.tableViewImageLoadTasks[indexPath] = Task {
        await cell.configure(for: item, storeItemController: self.storeItemController)
        self.tableViewImageLoadTasks[indexPath] = nil
      }
      return cell
    })
  }
  
  // MARK: - Fetch
  
  @objc func fetchMatchingItems() {
    self.items = []
    let searchTerm = searchController.searchBar.text ?? ""
    let mediaType = queryOptions[searchController.searchBar.selectedScopeButtonIndex]
    
    if !searchTerm.isEmpty {
      // set up query dictionary
      let query: [String: String] = [
        "term": searchTerm,
        "media": mediaType,
        "limit": "20",
        "lang": "en_us",
      ]
      // use the item controller to fetch items
      tableViewImageLoadTasks.values.forEach { task in task.cancel() }
      tableViewImageLoadTasks = [:]
      collectionViewImageLoadTasks.values.forEach { task in task.cancel() }
      collectionViewImageLoadTasks = [:]
      Task {
        do {
          let storeItems = try await storeItemController.fetchItems(matching: query)
          items = storeItems
          // apply data source changes
          await self.tableViewDataSource.apply(self.itemsSnapshot, animatingDifferences: true)
          await self.collectionViewDataSource.apply(self.itemsSnapshot, animatingDifferences: true)
        } catch {
          print("storeItemsError: \(error)")
        }
      }
    }
  }
  
}

extension StoreItemContainerViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchMatchingItems), object: nil)
    perform(#selector(fetchMatchingItems), with: nil, afterDelay: 0.3)
  }
}
