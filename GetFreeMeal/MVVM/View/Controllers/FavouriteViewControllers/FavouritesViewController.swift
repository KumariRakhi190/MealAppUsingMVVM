import UIKit

class FavouritesViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var searchTableView: UITableView! {
        didSet{
            searchTableView.register(UINib(nibName: "FavouritesTableViewCell", bundle: nil), forCellReuseIdentifier: "FavouritesTableViewCell")
            searchTableView.delegate = self
            searchTableView.dataSource = self
        }
    }
    
    //MARK: variable declaration
    private var viewModel = FavouritesViewModel()
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavouirteList()
        bindData()
    }
    
    func bindData() {
        viewModel.$favourites.sink { Favourites in
            if let count = Favourites?.count, count != 0 {
                self.searchTableView.restore()
                self.searchTableView.reloadData()
            } else {
                self.searchTableView.setEmptyMessage("no favourites")
            }
        }.store(in: &viewModel.cancellables)
        
        viewModel.$isRemoveFromFavouite.sink { isRemoved in
            if isRemoved {
                self.searchTableView.reloadData()
            }
        }.store(in: &viewModel.cancellables)
    }
 
}


extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favourites?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as! FavouritesTableViewCell
        let data = viewModel.favourites?[indexPath.row]
        cell.populateData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
        viewController.meal = viewModel.favourites?[indexPath.item]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action =  UIContextualAction(style: .destructive, title: "Remove", handler: { (action,view,completionHandler ) in
            let data = self.viewModel.favourites?[indexPath.row]
            self.viewModel.removeMealFromFavourites(data)
            completionHandler(true)

        })
        action.backgroundColor = UIColor.systemRed
        let confrigation = UISwipeActionsConfiguration(actions: [action])
        confrigation.performsFirstActionWithFullSwipe = false
        return confrigation
    }
    
}
