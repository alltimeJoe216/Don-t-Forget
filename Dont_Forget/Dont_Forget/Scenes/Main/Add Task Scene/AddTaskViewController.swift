//
//  AddTaskViewController.swift
//  Dont_Forget
//
//  Created by Joseph Veverka on 9/6/20.
//  Copyright © 2020 Joseph Veverka. All rights reserved.
//

import UIKit

protocol ReminderDelegate {
    func saveNewNote(title: String, date: Date, text: String)
}

protocol UpdateSectionCount {
    func updateSectionCount(for reminderFolderName: ReminderFolder, at indexPath: IndexPath)
}

class AddTaskViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet var textView: UITextView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var calendarButton: UIButton!
    @IBOutlet var dateTF: UITextField!
    @IBOutlet var titleTF: UITextField!
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK: - Properties
    
    let folderData = CoreDataManager.shared.fetchReminderFolders()
    var updateCountDelegate: UpdateSectionCount?
    var myIndexPath: IndexPath?
    var delegate: ReminderDelegate?
    
    var reminderData: Reminder! {
        
        didSet {
            titleTF.text = reminderData.title
            textView.text = reminderData.bodyText
            dateTF.text = df.string(from: reminderData.date ?? Date())
        }
    }
    var spacing: CGFloat = 2
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.reminderData == nil {
            delegate?.saveNewNote(title: titleTF.text ?? "", date: Date(), text: textView.text)
        } else {
            guard let newText = textView.text else { return }
            CoreDataManager.shared.saveUpdatedNote(reminder: self.reminderData, newText: newText)
        }
    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        
        guard let title = titleTF.text,
            let bodyText = textView.text,
            let date = df.date(from: dateTF.text ?? "")
            
            else { return }
        
        guard let collectionView = self.collectionView,
            let indexPath = collectionView.indexPathsForSelectedItems?.first,
            let cell = collectionView.cellForItem(at: indexPath) as? SelectSectionCollectionViewCell,
            let reminderSection = cell.folderData else { return }
        
    }
    
    func setupViews() {
        
        textView.placeholder = "..."
        textView.textViewDidChange(textView)
        bottomView.layer.cornerRadius = 25
        bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        titleTF.addBottomBorder()
        dateTF.addBottomBorder()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
        
    }
    
    func configureLayout() {
        collectionView.collectionViewLayout = createOneRowNestedGroupLayout()
    }
    
    func createOneRowNestedGroupLayout() -> UICollectionViewLayout {
        //2
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)))
        leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        //3
        let trailingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.7)))
        trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        
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
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
}

extension AddTaskViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        folderData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath) as! SelectSectionCollectionViewCell
        
        let sectionData = folderData
        cell.sectionNameLabel.text = sectionData[indexPath.item].title
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 2
        cell.layer.borderWidth = 0.5
        
        return cell
    }
}

extension AddTaskViewController: UpdateSectionCount {
    func updateSectionCount(for reminderFolderName: ReminderFolder, at indexPath: IndexPath) {
    }
    
    
}
