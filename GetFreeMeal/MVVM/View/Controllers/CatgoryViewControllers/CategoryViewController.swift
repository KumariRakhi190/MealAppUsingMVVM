import UIKit
import SDWebImage

class CategoryViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var categoryCollectionView: UICollectionView! {
        didSet {
            categoryCollectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
            categoryCollectionView.dataSource = self
            categoryCollectionView.delegate = self
        }
    }
    
    //MARK: variable declaration
    private var viewModel = CategoryViewModel()
    
    //MARK: view LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategoryList()
        bindData()
    }
    
    //MARK: Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func getCategoryList() {
        Loader.show()
        viewModel.getCategories()
    }
    
    func bindData() {
        viewModel.$categoriesOfMeal.sink { categories in
            if let count = categories?.count, count != 0 {
                self.categoryCollectionView.restore()
                self.categoryCollectionView.reloadData()
            } else {
                self.categoryCollectionView.setEmptyMessage("no categories are found")
            }
        }.store(in: &viewModel.cancellables)
        
        viewModel.$errorMessage.sink { error in
            if let error {
                Toast.show(message: error)
            }
        }.store(in: &viewModel.cancellables)
    }
}


extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoriesOfMeal?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
        let data = viewModel.categoriesOfMeal?[indexPath.row]
        cell.populateData(data)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 20) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let category = viewModel.categoriesOfMeal?[indexPath.item].strCategory {
            if let tabbarController = self.navigationController?.viewControllers.first(where: {$0 is UITabBarController}) as? UITabBarController,
                let viewController = tabbarController.viewControllers?.first(where: {$0 is HomeViewController}) as? HomeViewController {
                viewController.getHomeRecipe(search: category)
                viewController.searchTextField.text = category
                self.navigationController?.popToViewController(tabbarController, animated: true)
            }
        }
    }
    
}
