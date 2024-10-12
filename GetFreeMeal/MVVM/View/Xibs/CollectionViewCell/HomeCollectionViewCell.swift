
import UIKit
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.setBorderColourAndConerRadiusOfView(borderWidth: 1, color: .gray, cornerRadius: 18)
        recipeImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
    }
    
    func populateData(_ data: [String: String?]?) {
        recipeLabel.text = data?["strMeal"] ?? ""
        let image = data?["strMealThumb"] ?? ""
        recipeImage.sd_setImage(with: URL(string: image ?? ""))
    }

}
