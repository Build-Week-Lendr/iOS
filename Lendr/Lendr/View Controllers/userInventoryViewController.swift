//
//  UserInventoryViewController.swift
//  Lendr
//
//  Created by Thomas Sabino-Benowitz on 11/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class UserInventoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var networkingController: NetworkingController = NetworkingController()
    var itemController: ItemController = ItemController()

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var itemsAvailNumberLabel: UILabel!

    @IBOutlet weak var lentItemsLabel: UILabel!

    @IBOutlet weak var newItemButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Lendr"

        newItemButton.layer.backgroundColor = UIColor.lightGray.cgColor
        newItemButton.layer.cornerRadius = 6
        newItemButton.layer.borderColor = UIColor.black.cgColor
        newItemButton.layer.borderWidth = 1
        newItemButton.titleLabel?.font = UIFont(name: "Futura", size: 20)

        emailLabel.font = UIFont(name: "Futura", size: 20)

        networkingController.fetchUserInfo { userDetails, error in
            if let error = error {
                print("This is terrible! Error \(error)")
            }

            guard let userDetails = userDetails else {return}
            DispatchQueue.main.async {
                self.usernameLabel.text = userDetails.username.capitalized
                self.emailLabel.text = userDetails.email
            }
        }
        updateViews()

    }

    func updateViews() {
        guard let available = itemFetchedResultsController.fetchedObjects?.filter({$0.holder == nil}),
                  let lent = itemFetchedResultsController.fetchedObjects?.filter({$0.holder != nil}) else {return}

              itemsAvailNumberLabel.text = "\(available.count)"
              lentItemsLabel.text = "\(lent.count)"

    }

    lazy var itemFetchedResultsController: NSFetchedResultsController<Item> = {

           let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()

           fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

           let moc = CoreDataStack.shared.mainContext

           let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                managedObjectContext: moc,
                                                sectionNameKeyPath: nil,
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
        cell.detailTextLabel?.text = item.holder?.name ?? "Available"
        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemFetchedResultsController.object(at: indexPath)
            let moc = CoreDataStack.shared.mainContext
            itemController.deleteItem(item, context: moc) { (error) in
                if let error = error {
                    print("This is terrible! Error \(error)")
                }
            }
            do {
                try moc.save()
                tableView.reloadData()
            } catch {
                moc.reset()
                print("Error re-saving the managed object context: \(error)")
            }
        }
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return itemFetchedResultsController.sections?.count ?? 0
//    }
//

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailSegue" {
            if let detailVC = segue.destination as? ItemDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.item = itemFetchedResultsController.object(at: indexPath)
                detailVC.networkingController = networkingController
                detailVC.itemController = itemController
            }
        }
        if segue.identifier == "NewItemSegue" {
            if let createVC = segue.destination as? CreateItemViewController {
                createVC.networkingController = networkingController
                createVC.itemController = itemController

            }
        }
        if segue.identifier == "LendItemCellSegue" {
            if let createVC = segue.destination as? CreateItemViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                createVC.item = itemFetchedResultsController.object(at: indexPath)
                createVC.networkingController = networkingController
                createVC.itemController = itemController

            }
        }
    }

}
extension UserInventoryViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        updateViews()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
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
