import Foundation
import Combine

class FavouritesViewModel {
    
    @Published var favourites: [[String: String?]]?
    @Published var isRemoveFromFavouite: Bool = false
    var cancellables: Set<AnyCancellable> = []
    
    func getFavouirteList() {
        favourites = Favourites.shared.getFavourites()?.reversed()
    }

    func removeMealFromFavourites(_ data: [String: String?]?) {
        let id = data?["idMeal"] ?? ""
        Favourites.shared.removeItemFromFavourites(id: id ?? "")
        getFavouirteList()
        isRemoveFromFavouite = true
    }
    
}
