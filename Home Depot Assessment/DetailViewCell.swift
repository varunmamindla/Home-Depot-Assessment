//
//  DetailViewCell.swift
//  Home Depot Assessment
//
//  Created by Varun Mamindla on 5/13/18.
//  Copyright © 2018 Varun Mamindla. All rights reserved.
//

import UIKit

class DetailViewCell: UICollectionViewCell {
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Created: UILabel!
    @IBOutlet weak var License: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        Title.text = nil
        Description.text = nil
        Created.text = nil
        License.text = nil
    }
}
