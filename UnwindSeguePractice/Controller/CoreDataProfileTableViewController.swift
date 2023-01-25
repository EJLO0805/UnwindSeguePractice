//
//  CoreDataProfileTableViewController.swift
//  UnwindSeguePractice
//
//  Created by 羅以捷 on 2023/1/24.
//

import UIKit
import CoreData

class CoreDataProfileTableViewController: UITableViewController {
    
    enum Section{ case one}
    
    var profiles : [ProfileItemOfCoreData] = []
    
    var fetchController : NSFetchedResultsController<ProfileItemOfCoreData>!
    
    
    func confiugurationDataSoruce() -> UITableViewDiffableDataSource<Section, ProfileItemOfCoreData>{
        let dataSource = UITableViewDiffableDataSource<Section,ProfileItemOfCoreData>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "coreDataProfile", for: indexPath)
            cell.textLabel?.text = itemIdentifier.name
            return cell
        }
        return dataSource
    }
    
    lazy var dataSource = confiugurationDataSoruce()
    
    func updateSnaphot(){
        if let fetchObjects = fetchController.fetchedObjects {
            profiles = fetchObjects
        }
        var snaphot = NSDiffableDataSourceSnapshot<Section, ProfileItemOfCoreData>()
        snaphot.appendSections([.one])
        snaphot.appendItems(profiles, toSection: .one)
        dataSource.apply(snaphot, animatingDifferences: true)
    }
    
    func fetchProfileData(){
        let fetchReuest = ProfileItemOfCoreData.fetchRequest()
        fetchReuest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            fetchController = NSFetchedResultsController(fetchRequest: fetchReuest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchController.delegate = self
            do{
                try fetchController.performFetch()
                updateSnaphot()
            }catch{
                fatalError()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataSource = confiugurationDataSoruce()
        updateSnaphot()
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        tableView.dataSource = dataSource
        fetchProfileData()
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let profile = self.dataSource.itemIdentifier(for: indexPath) else { return UISwipeActionsConfiguration() }
        let deleteFunction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            let alertController = UIAlertController(title: "是否刪除資料", message: nil, preferredStyle: .alert)
            let deleteAlertAction = UIAlertAction(title: "OK", style: .default) { action in
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                    let context = appDelegate.persistentContainer.viewContext
                    context.delete(profile)
                    appDelegate.saveContext()
                }
            }
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(deleteAlertAction)
            alertController.addAction(cancelAlertAction)
            self.present(alertController, animated: true)
            completion(true)
        }
        
        let editFunction = UIContextualAction(style: .normal, title: "Edit") { action, view, completion in
            if let editProfileController = self.storyboard?.instantiateViewController(withIdentifier: "coreDataEditProfile") as? CoreDataEditProfileTableViewController{
                editProfileController.isNewProfile = false
                editProfileController.profile = profile
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
        if let destiantion = segue.destination as? CoreDataProfileDetailTableViewController, let indexPath = tableView.indexPathForSelectedRow {
            destiantion.profile = profiles[indexPath.row]
        }
    }

}

extension CoreDataProfileTableViewController: NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnaphot()
    }
}

