//
//  CreateItemViewController.swift
//  Lendr
//
//  Created by Thomas Sabino-Benowitz on 11/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class CreateItemViewController: UIViewController {

    var networkingController: NetworkingController!

    var itemController: ItemController!

    var userController: UserController = UserController()

    var item: Item?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var ownerLabel: UILabel!

    @IBOutlet weak var descriptionTextField: UITextField!

    @IBOutlet weak var borrowerTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.cornerRadius = 6
        notesTextView.layer.borderColor = UIColor.black.cgColor
//        nameTextField.text = item?.name
//        print("\(item)")
//        print("\(itemController)")

        networkingController.fetchUserInfo { userDetails, error in
                   if let error = error {
                       print("This is terrible! Error \(error)")
                   }

                   guard let userDetails = userDetails else {return}
                   DispatchQueue.main.async {
                       self.ownerLabel.text = userDetails.username.capitalized
                   }
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func saveButtonTapped(_ sender: Any) {

        if borrowerTextField.text != ""{
        guard let name = nameTextField.text,
        !name.isEmpty,
            let itemDescription = descriptionTextField.text,
            !itemDescription.isEmpty else {return}

        let borrowerName = borrowerTextField.text ?? ""
        let notes = notesTextView.text ?? ""
       let borrower = User(name: borrowerName, context: CoreDataStack.shared.mainContext)

        itemController.createItem(named: name,
                                  holder: borrower,
                                  itemDescription: itemDescription,
                                  lendNotes: notes,
                                  lendDate: Date(),
                                  context: CoreDataStack.shared.mainContext)
       navigationController?.popViewController(animated: true)
        } else if borrowerTextField.text == "" {
        guard let name = nameTextField.text,
          !name.isEmpty,
              let itemDescription = descriptionTextField.text,
              !itemDescription.isEmpty else {return}

          let notes = notesTextView.text ?? ""

            itemController.createItem(named: name,
                                      holder: nil,
                                      itemDescription: itemDescription,
                                      lendNotes: notes,
                                      lendDate: Date(),
                                      context: CoreDataStack.shared.mainContext)
         navigationController?.popViewController(animated: true)
        }
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
