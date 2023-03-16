//
//  trackingDetailTVCell.swift
//  Expenses(2.0)
//
//  Created by Mac on 12.03.2023.
//

import UIKit

class trackingDetailTVCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.costLabel.text = nil
        
    }
    
    func setupCell(expence: Expence) {
        self.nameLabel.text = expence.name
        self.costLabel.text = String(expence.cost)
    }
    
}
