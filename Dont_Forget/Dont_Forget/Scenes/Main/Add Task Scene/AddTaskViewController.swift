//
//  AddTaskViewController.swift
//  Dont_Forget
//
//  Created by Joseph Veverka on 9/6/20.
//  Copyright © 2020 Joseph Veverka. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet var textView: UITextView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var calendarButton: UIButton!
    @IBOutlet var dateTF: UITextField!
    @IBOutlet var titleTF: UITextField!
    @IBOutlet var collectionView: UICollectionView!
    
    
    var spacing: CGFloat = 2
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.placeholder = "..."
        textView.textViewDidChange(textView)
        bottomView.layer.cornerRadius = 25
        bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        topView.layer.cornerRadius = 25
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddTaskViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        CoreDataManager.shared.fetchReminderFolders().count
        
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
