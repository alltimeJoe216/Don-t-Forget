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
    var reminders: [Reminder] = []
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
    
//    @IBAction func createButtonTapped(_ sender: UIButton) {
//
//        guard let title = titleTF.text,
//            let bodyText = textView.text,
//            let date = df.date(from: dateTF.text ?? "")
//            else { return }
//
//        delegate?.saveNewNote(title: title, date: date, text: bodyText)
//        dismiss(animated: true, completion: nil)
//
//    }
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath) as! SelectSectionCollectionViewCell
        
        let sectionData = folderData
        cell.sectionNameLabel.text = sectionData[indexPath.item].title
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 2
        cell.layer.borderWidth = 0.5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? SelectSectionCollectionViewCell {
//            cell.showIcon()
        
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? SelectSectionCollectionViewCell {
//            cell.hideIcon()
        }
    
}


