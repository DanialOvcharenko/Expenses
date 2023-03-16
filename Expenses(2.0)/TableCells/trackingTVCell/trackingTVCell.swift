//
//  trackingTVCell.swift
//  Expenses(2.0)
//
//  Created by Mac on 11.03.2023.
//

import UIKit

class trackingTVCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.totalLabel.text = nil
        
    }
    
    func setupCell(expenceType: ExpenceType) {
        self.nameLabel.text = expenceType.name
        self.totalLabel.text = String(expenceType.total)
    }
    
}
