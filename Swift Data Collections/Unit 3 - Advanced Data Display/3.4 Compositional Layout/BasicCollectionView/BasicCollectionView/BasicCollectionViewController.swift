//
//  BasicCollectionViewController.swift
//  BasicCollectionView
//
//  Created by Quien on 2023/1/12.
//

import UIKit

private let reuseIdentifier = "BasicCell"
private let headerReuseIdendifier = "HeaderView"

class BasicCollectionViewController: UICollectionViewController {
  
  private let items = [
      "Alabama", "Alaska", "Arizona", "Arkansas", "California",
      "Colorado", "Connecticut", "Delaware", "Florida",
      "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
      "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
      "Massachusetts", "Michigan", "Minnesota", "Mississippi",
      "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
      "New Jersey", "New Mexico", "New York", "North Carolina",
      "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
      "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
      "Texas", "Utah", "Vermont", "Virginia", "Washington",
      "West Virginia", "Wisconsin", "Wyoming"
    ]
  lazy var filteredItem: [String] = self.items
  
  /// [:] merging ["A":["Alabama"]]
  /// ["A":["Alabama"]] merging ["A": ["Alaska"]] -> ["A": ["Alabama", "Alaska"]]
  lazy var itemsByInitialLetter: [Character: [String]] = self.filteredItem.reduce([:]) { existing, element in
    return existing.merging([element.first!: [element]]) { old, new in
      return old + new
    }
  }
  
  lazy var initialLetters: [Character] = self.itemsByInitialLetter.keys.sorted()
  
  var fillteredItemsSnapshot: NSDiffableDataSourceSnapshot<Character, String> {
    var snapshot = NSDiffableDataSourceSnapshot<Character, String>()
    for section in initialLetters {
      snapshot.appendSections([section])
      snapshot.appendItems(itemsByInitialLetter[section]!)
    }
    return snapshot
  }
  
  var dataSource: UICollectionViewDiffableDataSource<Character, String>!
  
  let searchController = UISearchController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Programmatically register a cell
    collectionView.setCollectionViewLayout(generateComplexLayout(), animated: false)
    navigationItem.searchController = searchController
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = true
    createDataSource()
  }
  
  private func createDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Character, String>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BasicCollectionViewCell
      cell.label.text = itemIdentifier
      return cell
    })
    
    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView in
      let  header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdendifier, for: indexPath) as! BasicHeaderView
      header.label.text = String(self.initialLetters[indexPath.section])
      return header
    }
    
    dataSource.apply(fillteredItemsSnapshot)
  }
  
  private func generateLayout() -> UICollectionViewLayout {
    // Compositional Layout
    
    let spacing: CGFloat = 10.0
    // Item
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
    // Group
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = spacing
    section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: 0, bottom: spacing, trailing: 0)
    // Seaction - Header
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(35))
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    section.boundarySupplementaryItems = [sectionHeader]
    // Layout
    let layout = UICollectionViewCompositionalLayout(section: section)
    
    return layout
  }
  
  private func generateComplexLayout() -> UICollectionViewLayout {
    let spacing: CGFloat = 2.0
    // Style 1: Full width
    let fullPhotoItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(2/3))
    )
    fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(
      top: spacing,
      leading: spacing,
      bottom: spacing,
      trailing: spacing
    )
    // Style 2: Main with a pair
    let mainItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(2/3),
        heightDimension: .fractionalHeight(1.0)
      )
    )
    mainItem.contentInsets = NSDirectionalEdgeInsets(
      top: spacing,
      leading: spacing,
      bottom: spacing,
      trailing: spacing
    )
    
    let pairItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(0.5)
      )
    )
    pairItem.contentInsets = NSDirectionalEdgeInsets(
      top: spacing,
      leading: spacing,
      bottom: spacing,
      trailing: spacing
    )
    
    let trailingGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1/3),
        heightDimension: .fractionalHeight(1.0)
      ),
      subitems: [pairItem, pairItem]
    )
    
    let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(4/9)
      ),
      subitems: [mainItem, trailingGroup]
    )
    // Style 3: Triplet
    let tripletItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1/3),
        heightDimension: .fractionalHeight(1.0))
    )
    tripletItem.contentInsets = NSDirectionalEdgeInsets(
      top: spacing,
      leading: spacing,
      bottom: spacing,
      trailing: spacing
    )
    let tripletGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(2/9)
      ),
      subitems: [tripletItem, tripletItem, tripletItem]
    )
    // Style 4: Reversed Style 2
    let reversedStyle2 = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(4/9)
      ),
      subitems: [trailingGroup, mainItem]
    )
    // Group
    let nestedGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(16/9)
      ),
      subitems: [fullPhotoItem, mainWithPairGroup, tripletGroup, reversedStyle2]
    )
    // Section
    let section = NSCollectionLayoutSection(group: nestedGroup)
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(35)
    )
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [sectionHeader]
    // Layout
    let layout = UICollectionViewCompositionalLayout(section: section)
    
    return layout
  }
  
}

extension BasicCollectionViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if let searchString = searchController.searchBar.text, !searchString.isEmpty {
      filteredItem = items.filter { $0.localizedCaseInsensitiveContains(searchString) }
    } else {
      filteredItem = items
    }
    
    itemsByInitialLetter = filteredItem.reduce([:], { existing, element in
      return existing.merging([element.first!: [element]]) { old, new in
        return old + new
      }
    })
    
    initialLetters = itemsByInitialLetter.keys.sorted()
    dataSource.apply(fillteredItemsSnapshot, animatingDifferences: true)
  }
}
