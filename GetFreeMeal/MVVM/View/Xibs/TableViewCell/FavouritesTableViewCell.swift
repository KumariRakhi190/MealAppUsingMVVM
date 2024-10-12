import UIKit

class FavouritesTableViewCell: UITableViewCell {

    @IBOutlet weak var foodDescriptionLabel: UILabel!
    @IBOutlet weak var foodTitleLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
    }
    
    func populateData(_ data: [String: String?]?) {
        foodTitleLabel.text = data?["strMeal"] ?? ""
        let image = data?["strMealThumb"] ?? ""
        foodImageView.sd_setImage(with: URL(string: image ?? ""))
        foodDescriptionLabel.text = data?["strInstructions"] ?? ""
    }
    
}
