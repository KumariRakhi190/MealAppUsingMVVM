import UIKit
import SDWebImage

class RecipeDetailsViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var decsriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var ingrediantTableView: UITableView! {
        didSet {
            ingrediantTableView.register(UINib(nibName: "IngredientsTableViewCell", bundle: nil), forCellReuseIdentifier: "IngredientsTableViewCell")
            ingrediantTableView.dataSource = self
            ingrediantTableView.dataSource = self
            ingrediantTableView.addObserver(self, forKeyPath: "contentSize", context: nil)
        }
    }
    
    
    //MARK: Variable decalaration
    private var viewModel = RecipeDetailsViewModel()
    var meal: [String: String?]?
    
    //MARK: View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getRecipeDetailData(meal: meal)
        bindData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? UITableView == ingrediantTableView{
            ingredientTableViewHeight.constant = ingrediantTableView.contentSize.height
        }
    }
    
    //Button's Action
    @IBAction func didTapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapHeart(_ sender: Any) {
        viewModel.handleHeartDidTapped(meal)
    }
    
    func bindData() {
        viewModel.$ingredientList.sink { ingredients in
            let count = ingredients.count
            if count != 0 {
                self.ingrediantTableView.restore()
                self.ingrediantTableView.reloadData()
            } else {
                self.ingrediantTableView.setEmptyMessage("no data found")
            }
            
        }.store(in: &viewModel.cancellables)
        
        viewModel.$isAddedToFavourites.sink { isLike in
            if isLike {
                self.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                self.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }.store(in: &viewModel.cancellables)
        
        viewModel.$mealName.sink { name in
            self.titleLabel.text = name
            
        }.store(in: &viewModel.cancellables)
        
        viewModel.$mealDescription.sink { description in
            
            self.decsriptionLabel.text = description
            
        }.store(in: &viewModel.cancellables)
        
        viewModel.$mealCategory.sink { category in
            self.categoryLabel.text = category
            
            
        }.store(in: &viewModel.cancellables)
        viewModel.$mealCuisine.sink { cusine in
            self.cuisineLabel.text = cusine
        }.store(in: &viewModel.cancellables)
        
        viewModel.$mealImage.sink { image in
            if let image {
                self.thumbImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.thumbImageView.sd_setImage(with: URL(string: image))
            }
        }.store(in: &viewModel.cancellables)
    }
    
}


extension RecipeDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell", for: indexPath) as! IngredientsTableViewCell
        let data = viewModel.ingredientList[indexPath.row]
        cell.populateData(title: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
