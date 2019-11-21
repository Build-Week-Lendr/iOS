//
//  userInventoryViewController.swift
//  Lendr
//
//  Created by Thomas Sabino-Benowitz on 11/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class userInventoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var itemsAvailNumberLabel: UILabel!
    
    @IBOutlet weak var lentItemsLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
//        usernameLabel.text =
        // Do any additional setup after loading the view.
    }
    

    
    lazy var itemFetchedResultsController: NSFetchedResultsController<Item> = {
           
           let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
           
           fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
           
           let moc = CoreDataStack.shared.mainContext
           
           let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                managedObjectContext: moc,
                                                sectionNameKeyPath: "name",
                                                cacheName: nil)
           
           frc.delegate = self
           
           do {
               try frc.performFetch()
               return frc
           } catch {
               print("failed to fetch entries: \(error)")
               fatalError()
           }
           
       }()
    
//    func setUpView() {
//          let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
//              fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
//    }
   
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemFetchedResultsController.fetchedObjects?.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = itemFetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = item.name
        return cell
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        <#code#>
//    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension userInventoryViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
    
}
