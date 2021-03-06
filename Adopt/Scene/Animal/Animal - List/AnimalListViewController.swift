//
//  Copyright © 2020 Damian Rzeszot. All rights reserved.
//

import UIKit

class AnimalListViewController: UIViewController, UICollectionViewDelegate, UISearchResultsUpdating {

    // MARK: -

    var category: ((CategoriesModel.Category) -> Void)!
    var details: (() -> Void)!

    // MARK: -

    @IBOutlet
    var collectionView: UICollectionView!

    // MARK: -

    var model: AnimalsListModel!
    var source: UICollectionViewDiffableDataSource<String, String>!

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        source = UICollectionViewDiffableDataSource<String, String>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, _) -> UICollectionViewCell? in

            switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath)
                (cell as? CategoryCell)?.titleLabel.text = self.model.categories.items[indexPath.row].name
                return cell

            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animal", for: indexPath)
                (cell as? AnimalListEntryCell)?.configure(item: self.model.animals.items[indexPath.row])
                return cell

            default:
                fatalError()
            }
        })

        source.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            (header as? AnimalListHeaderView)?.titleLabel.text = ["Kategoria", "Najnowsze"][indexPath.section]
            return header
        }

        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(["categories"])
        snapshot.appendItems(model.categories.items.map { $0.id })
        snapshot.appendSections(["animals"])
        snapshot.appendItems(model.animals.items.map { $0.id.uuidString })
        source.apply(snapshot)

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.create(for: model)
        collectionView.dataSource = source
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let xxx = model.categories.items[indexPath.row]

            category(CategoriesModel.Category(id: xxx.id, name: xxx.name))
        } else {
            details()
        }
    }

    // MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        print("seach \(text)")
    }

}

private extension UICollectionViewCompositionalLayout {
    static func create(for model: AnimalsListModel) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return NSCollectionLayoutSection.categories
            case 1:
                return NSCollectionLayoutSection.animals
            default:
                return nil
            }
        }

        return layout
    }
}

private extension NSCollectionLayoutSection {
    static var categories: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.42), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem.header]
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        return section
    }

    static var animals: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize( widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem.header]
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        return section
    }
}

private extension NSCollectionLayoutBoundarySupplementaryItem {
    static var header: NSCollectionLayoutBoundarySupplementaryItem {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}
