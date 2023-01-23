//
//  StoreItemCollectionViewController.swift
//  iTunesSearch
//
//  Created by Quien on 2023/1/16.
//

import UIKit

private let reuseIdentifier = "Cell"

class StoreItemCollectionViewController: UICollectionViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let spacing: CGFloat = 8
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1/3),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(0.5)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(
      top: spacing,
      leading: spacing,
      bottom: spacing,
      trailing: spacing
    )
    section.interGroupSpacing = spacing
    
    collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
  }
  
  
}
