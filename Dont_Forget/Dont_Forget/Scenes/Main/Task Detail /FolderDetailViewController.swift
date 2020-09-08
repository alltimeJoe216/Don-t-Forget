//
//  FolderDetailViewController.swift
//  Dont_Forget
//
//  Created by Joseph Veverka on 9/6/20.
//  Copyright © 2020 Joseph Veverka. All rights reserved.
//

import UIKit

class FolderDetailViewController: UIViewController {

    @IBOutlet var noteLabel: UILabel!
    var reminderCell: String = "reminderCell"
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(FolderDetailCollectionViewCell.self, forCellWithReuseIdentifier: self.reminderCell)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func configureLayout() {
        collectionView.collectionViewLayout = createTwoRowsNestedGroupLayout()
    }
    
    func createOneRowNestedGroupLayout() -> UICollectionViewLayout {
        //2
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)))
        leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        //3
        let trailingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.7)))
        trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        //4
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)),
            subitem: trailingItem, count: 2)

        //5
        let nestedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitems: [leadingItem, trailingGroup])

        //6
        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func createTwoRowsNestedGroupLayout() -> UICollectionViewLayout {
        //2
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)))
        leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let trailingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)))
        trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)),
            subitem: trailingItem, count: 2)

        let topNestedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitems: [leadingItem, trailingGroup])

        //3
        let bottomNestedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitems: [trailingGroup, leadingItem])

        //4
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                              heightDimension: .fractionalHeight(0.5)),
                                                           subitems: [topNestedGroup, bottomNestedGroup])
        nestedGroup.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}
