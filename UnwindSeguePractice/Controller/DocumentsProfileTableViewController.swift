//
//  DocumentsProfileTableViewController.swift
//  UnwindSeguePractice
//
//  Created by 羅以捷 on 2022/11/29.
//

import UIKit

class DocumentsProfileTableViewController: UITableViewController {
    var profiles : [ProfileItem] = []{
        didSet{
            ProfileItem.documentsSaveProfile(profiles)
        }
    }
    var selectedIndexPath : IndexPath?
    
    override func viewWillAppear(_ animated: Bool) {
        selectedIndexPath = nil
    }
    
    override func viewDidLoad() {
        if let profiles = ProfileItem.documentsLoadProfiles(){
            self.profiles = profiles
        }
        super.viewDidLoad()
        
    }
    
    @IBAction func unwindToDocumentsProfileTableView(_ unwindSegue: UIStoryboardSegue) {
        if let source = unwindSegue.source as? DocumentsEditProfileTableViewController, let profile = source.profile {
            if let indexPath = selectedIndexPath{
                profiles[indexPath.row] = profile
                tableView.reloadRows(at: [indexPath], with: .none)
                
            }else {
                profiles.insert(profile, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .left)
                
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return profiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentsProfile", for: indexPath)
        
        cell.textLabel?.text = profiles[indexPath.row].name
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteFunction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            let alertController = UIAlertController(title: "是否刪除資料", message: nil, preferredStyle: .alert)
            let deleteAlertAction = UIAlertAction(title: "OK", style: .default) { action in
                self.profiles.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(deleteAlertAction)
            alertController.addAction(cancelAlertAction)
            self.present(alertController, animated: true)
            completion(true)
        }
        
        let editFunction = UIContextualAction(style: .normal, title: "Edit") { action, view, completion in
            if let editProfileController = self.storyboard?.instantiateViewController(withIdentifier: "documnetsEditProfile") as? DocumentsEditProfileTableViewController{
                editProfileController.profile = self.profiles[indexPath.row]
                self.selectedIndexPath = indexPath
                self.navigationController?.pushViewController(editProfileController, animated: true)
            }
            completion(true)
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteFunction,editFunction])
        return swipeConfiguration
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let showDetailController = segue.destination as? DocumentsDetailProfileTableViewController, let indexPath = tableView.indexPathForSelectedRow {
            showDetailController.profile = profiles[indexPath.row]
            selectedIndexPath = tableView.indexPathForSelectedRow
        }
    }
    
}
