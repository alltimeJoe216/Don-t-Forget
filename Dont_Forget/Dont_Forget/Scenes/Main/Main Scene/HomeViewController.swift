//
//  HomeViewController.swift
//  Dont_Forget
//
//  Created by Joseph Veverka on 9/5/20.
//  Copyright © 2020 Joseph Veverka. All rights reserved.
//

import UIKit


extension HomeViewController: UpdateSectionCount {
    func updateSectionCount(for reminderFolderName: ReminderFolder, at indexPath: IndexPath) {
        self.reminderFolders[indexPath.row] = reminderFolderName
        self.collectionView.reloadData()
    }
}
class HomeViewController: UIViewController {
    
    static let shared = HomeViewController()
//    let dateString =

    enum Section {
        case main
    }
    
    //MARK: - IBOutlet
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var addSectionButton: UIButton!
    @IBOutlet var todayInfoView: UIView!
    
    //MARK: - Properties
    var reminderFolders: [ReminderFolder] = []
    fileprivate var reminders:[Reminder] = []
    fileprivate var filteredReminders:[Reminder] = []
    
    var folderData: ReminderFolder! {
        didSet {
            reminders = CoreDataManager.shared.fetchNotes(from: folderData)
            filteredReminders = reminders
        }
    }
    
    
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
        configureLayout()
        //Stylizing
        Utilities.styleHollowButton(addSectionButton)
        todayInfoView.layer.cornerRadius = 15
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
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    
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
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = randomColors().cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
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
