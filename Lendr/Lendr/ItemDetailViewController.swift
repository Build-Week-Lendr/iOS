//
//  ItemDetailViewController.swift
//  Lendr
//
//  Created by Thomas Sabino-Benowitz on 11/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var borrowItemButton: UIButton!
    @IBOutlet weak var lendItemButton: UIButton!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var holderLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        // Do any additional setup after loading the view.
    }
    
    func setUpViews() {
        ownerLabel.font = UIFont(name: "Futura", size: 32)
        
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
