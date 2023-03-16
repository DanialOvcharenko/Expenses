//
//  historyExpenceTVCell.swift
//  Expenses(2.0)
//
//  Created by Mac on 14.03.2023.
//

import UIKit

class historyExpenceTVCell: UITableViewCell {

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
    
    func setupCell(historyExpence: HistoryExpence) {
        self.nameLabel.text = historyExpence.name
        self.totalLabel.text = "Total: $\(historyExpence.total)"
    }
    
}
