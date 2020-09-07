//
//  HomeViewController.swift
//  Dont_Forget
//
//  Created by Joseph Veverka on 9/5/20.
//  Copyright © 2020 Joseph Veverka. All rights reserved.
//

import UIKit





@IBDesignable
class HomeViewController: UIViewController {
    
    static let shared = HomeViewController()
//    let dateString =

    enum Section {
        case main
    }
    
    //MARK: - IBOutlet
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var addReminderButtonOutlet: UIButton!
    @IBOutlet var todayTableView: UITableView!
    @IBOutlet var addSectionButton: UIButton!
    
    //MARK: - Properties
    var reminderFolders: [ReminderFolder] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    
    //MARK: - Private Properties
    fileprivate var reminderCell: String = "reminderCell" // For CV Cell
    
    fileprivate let headerView: UIView = {
        
        // HeaderView
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: 40))
        
        let label = UILabel(frame: CGRect(x: 20,
                                          y: 15,
                                          width: 250,
                                          height: 20))
        
    
        label.text = "is \(df.string(from: Date())) at \(df2.string(from: Date()))"
        label.font = UIFont.init(name: "Gill Sans", size: 13)
        label.textColor = .darkGray
        
        headerView.addBorder(toSide: .bottom,
                             withColor: UIColor.lightGray.withAlphaComponent(0.5).cgColor,
                             andThickness: 0.3)
        
        headerView.addSubview(label)
        return headerView
    }()

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        todayTableView.tableHeaderView = headerView
        configureLayout()
        //Stylizing
        Utilities.styleHollowButton(addReminderButtonOutlet)
        Utilities.styleHollowButton(addSectionButton)
        
        reminderFolders = CoreDataManager.shared.fetchReminderFolders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        translucentToolBars()
    }
    
    //MARK: - IBActions
    
    @IBAction func deleteSection(_ sender: Any) {
    }
    var textField:UITextField!
    
    @IBAction func addSectionButtonAction(_ sender: Any) {
        
        let addAlert = UIAlertController(title: "New Section", message: "Enter a name for this bitch", preferredStyle: .alert)
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            addAlert.dismiss(animated: true)
        }))
        
        addAlert.addTextField { (tf) in
            self.textField = tf
        }
        
        addAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            
            addAlert.dismiss(animated: true)
            
            guard let title = self.textField.text else { return }
            let newFolder = CoreDataManager.shared.createReminderFolder(title: title)
            self.reminderFolders.append(newFolder)
            self.collectionView.insertItems(at: [IndexPath(row: self.reminderFolders.count - 1, section: 0)])
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }))
        
        present(addAlert, animated: true)
        
    }
    //MARK: - Class Functions

    fileprivate func translucentToolBars() {

        let toolbar = navigationController?.toolbar
        let navigationBar = self.navigationController?.navigationBar
        let slightWhite = getImage(withColor: UIColor.white.withAlphaComponent(0.9),
                                   andSize: CGSize(width: 30,
                                                   height: 30))

        toolbar?.setBackgroundImage(slightWhite,
                                    forToolbarPosition: .any,
                                    barMetrics: .default)
        toolbar?.setShadowImage(UIImage(), forToolbarPosition: .any)

        navigationBar?.setBackgroundImage(slightWhite,
                                          for: .default)
        navigationBar?.shadowImage = slightWhite

    }
    
    fileprivate func getImage(withColor color: UIColor, andSize size: CGSize) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        // creating a graphics image context so we can fill it w/ color.
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    fileprivate func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in

        // Get a cell of the desired kind.
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: self.reminderCell,
            for: indexPath) as? ReminderFolderCollectionViewCell
            else { fatalError("Cannot create new cell") }

        // Cell view properties
        cell.sectionNameLabel.text = "\(identifier)"
        cell.layer.borderWidth = 2.90
        cell.contentView.layer.borderColor = UIColor.white.cgColor
        cell.contentView.layer.masksToBounds = true
//        cell.layer.shadowColor = self.randomColors().cgColor
        cell.layer.shadowOffset = CGSize(width: 10, height: 5)
        cell.layer.shadowRadius = 15.0
        cell.layer.shadowOpacity = 2.0
        cell.layer.cornerRadius = 15.0
//        cell.backgroundColor = self.randomColors()

        return cell
    }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<30))
        dataSource.apply(snapshot, animatingDifferences: false)
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
        collectionView.collectionViewLayout = createOneRowNestedGroupLayout()
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


        //5
        let nestedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitems: [leadingItem])

        //6
        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    //MARK: - TableView
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }

    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reminderFolders.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reminderFolderCell", for: indexPath) as! ReminderFolderCollectionViewCell
        let folderForRow = reminderFolders[indexPath.row]
        cell.folderData = folderForRow
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 12
        cell.layer.borderWidth = 1
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            deleteButton.isEnabled = false
        } else {
            deleteButton.isEnabled = true
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
            deleteButton.isEnabled = false
        }
    }
    
    
    
    
    
    
    
    
    
    
}
