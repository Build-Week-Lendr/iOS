//
//  ItemDetailViewController.swift
//  Lendr
//
//  Created by Thomas Sabino-Benowitz on 11/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    
    var item: Item!
    var networkingController: NetworkingController!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var lendItemButton: UIButton!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var holderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setUpView() {
           ownerLabel.font = UIFont(name: "Futura", size: 32)
            holderLabel.font = UIFont(name: "Futura", size: 32)
           nameLabel.text = item.name
           notesTextView.text = item.lendNotes
            holderLabel.text = item.holder?.name ?? "You"
        dateLabel.text = "\(item.lentDate!)"
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        print("\(item)")
        networkingController.fetchUserInfo { userDetails, error in
            if let error = error {
                print("This is terrible! Error \(error)")
            }
            
            guard let userDetails = userDetails else {return}
            DispatchQueue.main.async {
                self.ownerLabel.text = userDetails.username.capitalized
                
            }
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
