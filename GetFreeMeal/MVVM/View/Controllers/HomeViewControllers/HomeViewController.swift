import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlet
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var homeCollectionView: UICollectionView! {
        didSet {
            homeCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
            homeCollectionView.delegate = self
            homeCollectionView.dataSource = self
            homeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
    
    //MARK: variable declaration
    private var viewModel = HomeViewModel()
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getHomeRecipe()
        bindData()
        searchTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchView.setBorderColourAndConerRadiusOfView(borderWidth: 1, color: .gray, cornerRadius: 8)
        self.tabBarController?.tabBar.layer.borderWidth  = 1.2
        self.tabBarController?.tabBar.layer.borderColor = UIColor.systemRed.cgColor
    }
    
    
    //MARK: API Calling
    func getHomeRecipe(search: String? = nil){
        Loader.show()
        viewModel.getHomeRecipe(search: search ?? "")
    }
    
    func bindData() {
        viewModel.$homeRecipe.sink { meals in
            if let count = meals?.meals?.count, count != 0 {
                self.homeCollectionView.restore()
                self.homeCollectionView.reloadData()
                } else {
                    self.homeCollectionView.setEmptyMessage("No data found")
            }
        }.store(in: &viewModel.cancellable)
        
        viewModel.$errorMessage.sink { error in
            if let error {
                Toast.show(message: error)
            }
        }.store(in: &viewModel.cancellable)
        
        viewModel.$randomMeal.sink { randomMeal in
            if let meal = randomMeal?.meals?.first{
                let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
                detailsViewController.meal = meal
                self.navigationController?.pushViewController(detailsViewController, animated: true)
            }
        }.store(in: &viewModel.cancellable)
    }
    
    
    //MARK: Button's Action
    @IBAction func didTapRandomMeal(_ sender: Any) {
        Loader.show()
        viewModel.getRandomMeal()
    }
    
    @IBAction func didTapFilters(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.homeRecipe?.meals?.count ?? .zero
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        let data = viewModel.homeRecipe?.meals?[indexPath.row]
        cell.populateData(data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-20)/2
        return CGSize(width: width, height: width*1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
        viewController.meal = viewModel.homeRecipe?.meals?[indexPath.item]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}


extension HomeViewController {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let searchStr = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if searchStr.isEmpty{
            getHomeRecipe()
        }
        else{
            viewModel.searchUserWorkItemReference?.cancel()
            let serachItem = DispatchWorkItem { [self] in
                getHomeRecipe(search: searchStr)
            }
            viewModel.searchUserWorkItemReference = serachItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(500), execute: serachItem)
        }
    }
}
