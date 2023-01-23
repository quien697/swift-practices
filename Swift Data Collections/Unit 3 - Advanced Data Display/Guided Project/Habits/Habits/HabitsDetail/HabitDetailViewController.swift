//
//  HabitDetailViewController.swift
//  Habits
//
//  Created by Quien on 2023/1/20.
//

import UIKit

class HabitDetailViewController: UIViewController {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var habit: Habit!
  
  required init?(coder: NSCoder, habit: Habit) {
    super.init(coder: coder)
    self.habit = habit
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
  
  enum ViewModel {
    enum Section: Hashable {
      case leaders(count: Int)
      case remaining
    }
    
    enum Item: Hashable, Comparable {
      case single(_ stat: UserCount)
      case multiple(_ stats: [UserCount])
      
      static func < (_ lhs: Item, _ rhs: Item) -> Bool {
        switch (lhs, rhs) {
        case (.single(let lCount), .single(let rCount)):
          return lCount.count < rCount.count
        case (.multiple(let lCounts), .multiple(let rCounts)):
          return lCounts.first!.count < rCounts.first!.count
        case (.single, .multiple):
          return false
        case (.multiple, .single):
          return true
        }
      }
    }
  }
  
  struct Model {
    var habitStatistics: HabitStatistics?
    var userCounts: [UserCount] {
      habitStatistics?.userCounts ?? []
    }
  }
  
  var dataSource: DataSourceType!
  var model = Model()
  
  var updateTimer: Timer?
  
  // Keep track of async tasks so they can be cancelled when appropriate
  var habitStatisticsRequestTask: Task<Void, Never>? = nil
  deinit { habitStatisticsRequestTask?.cancel() }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nameLabel.text = habit.name
    categoryLabel.text = habit.category.name
    infoLabel.text = habit.info
    
    dataSource = createDataSource()
    collectionView.dataSource = dataSource
    collectionView.collectionViewLayout = createLayout()
    update()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    update()
    updateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      self.update()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    updateTimer?.invalidate()
    updateTimer = nil
  }
  
  // MARK: - Update UI
  
  func update() {
    habitStatisticsRequestTask?.cancel()
    habitStatisticsRequestTask = Task {
      if let statistics = try? await HabitStatisticsRequest(habitNames: [habit.name]).send(), statistics.count > 0 {
        self.model.habitStatistics = statistics[0]
      } else {
        self.model.habitStatistics = nil
      }
      self.updateCollectionView()
      habitStatisticsRequestTask = nil
    }
  }
  
  func updateCollectionView() {
    let items = (self.model.habitStatistics?.userCounts.map{ ViewModel.Item.single($0) } ?? []).sorted(by: >)
    dataSource.applySnapshotUsing(sectionIDs: [.remaining], itemsBySection: [.remaining: items])
  }
  
  // MARK: - UICollectionViewDataSource
  
  func createDataSource() -> DataSourceType {
    return DataSourceType(collectionView: collectionView){ (collectionView, indexPath, grouping) ->
      UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCount", for: indexPath) as! UICollectionViewListCell
      var content = UIListContentConfiguration.subtitleCell()
      content.prefersSideBySideTextAndSecondaryText = true
      switch grouping {
      case .single(let userStat):
        content.text = userStat.user.name
        content.secondaryText = "\(userStat.count)"
        content.textProperties.font = .preferredFont(forTextStyle: .headline)
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
      default:
        break
      }
      cell.contentConfiguration = content
      return cell
    }
  }
  
  // MARK: - UICollectionView Layout
  
  func createLayout() -> UICollectionViewCompositionalLayout {
    // Item
    let itemSize =
    NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12)
    // Group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .absolute(44)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
    // Layout
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
  
}
