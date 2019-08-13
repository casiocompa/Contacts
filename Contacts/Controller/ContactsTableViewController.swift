//
//  ContactsTableViewController.swift
//  Contacts
//
//  Created by Ruslan Kasian on 8/9/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//

import UIKit
import CoreData

class ContactsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController = CoreDataManager.sharedInstance.fetchedResultsController("Person", keyForSort: "firstName")
        
    private var navigationBarTitle: String = "Contacts"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: .zero)
        setupNavigationBar ()
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    // MARK: - View setup
    private func setupNavigationBar() {
        self.title = navigationBarTitle
        let addNewContactButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewContactButtonAction))
        self.navigationItem.rightBarButtonItem = addNewContactButtonItem
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
            tableView.refreshControl?.attributedTitle = NSAttributedString (string: "fetch data ...")
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
             self.navigationController?.navigationBar.prefersLargeTitles = false
            tableView.backgroundView = refreshControl            
        }
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {

        refreshControl.beginRefreshing()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        refreshControl.endRefreshing()
    }

    @objc private func addNewContactButtonAction() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let personVC = storyboard.instantiateViewController(withIdentifier: "PersonVC") as? PersonTableViewController else { return }
        personVC.initType = .create
        personVC.fetchedResultsController = fetchedResultsController
        navigationController?.pushViewController(personVC, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        let person = fetchedResultsController.object(at: indexPath) as! Person
        cell.personInfo =  person
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let personVC = storyboard.instantiateViewController(withIdentifier: "PersonVC") as? PersonTableViewController else { return }
        personVC.initType = .show
        let person = fetchedResultsController.object(at: indexPath) as! Person
        personVC.person =  person
        personVC.fetchedResultsController = fetchedResultsController
        navigationController?.pushViewController(personVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObject = fetchedResultsController.object(at: indexPath) as! NSManagedObject
            CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(managedObject)
            CoreDataManager.sharedInstance.saveContext()
        }
    }
    
    // MARK: - Fetched Results Controller Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.refreshControl?.beginRefreshing()
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactTableViewCell else {
                    return 
                }
                
                let person = fetchedResultsController.object(at: indexPath) as! Person
                cell.personInfo =  person
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        tableView.refreshControl?.endRefreshing()
    }
}

