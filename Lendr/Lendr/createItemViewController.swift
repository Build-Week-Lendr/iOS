//
//  createItemViewController.swift
//  Lendr
//
//  Created by Thomas Sabino-Benowitz on 11/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class createItemViewController: UIViewController{
    
    var itemController: ItemController!
   
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
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
        !name.isEmpty,
            let description = descriptionTextField.text,
            !description.isEmpty,
            let borrowerName = borrowerTextField.text,
            !borrowerName.isEmpty else {return}
        
        let notes = notesTextView.text
        let borrower = User(name: borrowerName, context: CoreDataStack.shared.mainContext)
      
//        itemController.createItem(named: name, holder: borrower, itemDescription: description, lendNotes: notes, lendDate: Date(), context: CoreDataStack.shared.mainContext, completion: <#T##(Item?, Error?) -> Void#>)
    }
    

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
