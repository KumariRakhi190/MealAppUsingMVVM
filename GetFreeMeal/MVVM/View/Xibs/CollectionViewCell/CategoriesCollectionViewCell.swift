import UIKit
import SDWebImage

class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.setBorderColourAndConerRadiusOfView(borderWidth: 1, color: .gray, cornerRadius: 18)
        categoryImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    }
    
    func populateData(_ data: GetMealCategoryData?) {
        categoryImageView.sd_setImage(with: URL(string: data?.strCategoryThumb ?? ""))
        titleLabel.text = data?.strCategory
    }

}
