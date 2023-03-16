//
//  expenceTypeTVCell.swift
//  Expenses(2.0)
//
//  Created by Mac on 11.03.2023.
//

import UIKit

class expenceTypeTVCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        
    }
    
    func setupCell(expenceType: ExpenceType) {
        self.nameLabel.text = expenceType.name
    }
    
}
