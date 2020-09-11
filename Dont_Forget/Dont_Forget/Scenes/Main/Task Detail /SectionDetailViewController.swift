//
//  FolderDetailViewController.swift
//  Dont_Forget
//
//  Created by Joseph Veverka on 9/6/20.
//  Copyright © 2020 Joseph Veverka. All rights reserved.
//

import UIKit

extension SectionDetailViewController: ReminderDelegate {
    
    func saveNewNote(title: String, date: Date, text: String) {
        
        let newNote = CoreDataManager.shared.createNewNote(title: title, date: date, bodyText: text, reminderFolder: self.reminderFolder!)
        
        reminders.append(newNote)
        
        let index = tableView.indexPathForSelectedRow
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell") as? SectionDetailTableViewCell
//        cell?.reminderData = reminders[index]
        
        
        self.tableView.reloadData()
    }
}

class SectionDetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var sectionNameLabel: UILabel!

    //MARK: -Properties
    fileprivate var reminders:[Reminder] = []
    var reminderFolder: ReminderFolder?
        
    var folderData: ReminderFolder! {
        didSet {
            
            reminders = CoreDataManager.shared.fetchNotes(from: folderData)
            
            print(reminders)
        }
    }
    
    
    
    // Cell ID
    var reminderCell: String = "reminderCell"
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        tableView.register(SectionDetailTableViewCell.self, forCellReuseIdentifier: reminderCell)

        super.viewDidLoad()
        tableView.reloadData()
        sectionNameLabel.text = reminderFolder?.title
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    //MARK: -IBactions
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddNotes" {
        let destination = segue.destination as? AddTaskViewController
        destination?.delegate = self
            
        }
    }
}

extension SectionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.reminders.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reminderCell, for: indexPath) as! SectionDetailTableViewCell
        let reminderForRow = reminders[indexPath.row]
        cell.reminderData =  reminderForRow
        cell.reminderTitle.text = reminders[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}
