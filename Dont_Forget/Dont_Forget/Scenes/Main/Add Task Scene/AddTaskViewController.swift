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
    var reminderFolder: ReminderFolder?
    var delegate2: UpdateSectionCount?
    var indexPath: IndexPath?
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
        

        CoreDataManager.shared.createNewNote(title: title, date: date, bodyText: bodyText, reminderFolder: reminderFolder!)
        
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
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     

}

extension AddTaskViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        CoreDataManager.shared.fetchReminderFolders().count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let sectionData = CoreDataManager.shared.fetchReminderFolders()
        
        if let delegate = delegate2 

    }



func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath) as! SelectSectionCollectionViewCell
    
    let sectionData = CoreDataManager.shared.fetchReminderFolders()
    cell.sectionNameLabel.text = sectionData[indexPath.item].title
    cell.layer.borderColor = UIColor.black.cgColor
    cell.layer.cornerRadius = 2
    cell.layer.borderWidth = 0.5
    
    return cell
}




}
