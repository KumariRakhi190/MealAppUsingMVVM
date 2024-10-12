//
//  IngredientsTableViewCell.swift
//  FreeMeal
//
//  Created by Rakhi Kumari on 14/09/24.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(title: String?) {
        titleLabel.text = "• \(title ?? "")"
    }
    
}
