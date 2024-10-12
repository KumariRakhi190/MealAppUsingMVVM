import Foundation
import Combine

class RecipeDetailsViewModel {
    
    @Published var isAddedToFavourites: Bool = false
    @Published var mealName: String?
    @Published var mealImage: String?
    @Published var mealDescription: String?
    @Published var mealCategory: String?
    @Published var mealCuisine: String?
    @Published var ingredientList = [String]()
    
    var cancellables: Set<AnyCancellable> = []
    var favourites = Favourites.shared.getFavourites()
    
    func handleHeartDidTapped(_ meal: [String: String?]?) {
        let id = meal?["idMeal"] ?? ""
        if favourites?.contains(where: {$0["idMeal"] == id}) ?? false{
            Favourites.shared.removeItemFromFavourites(id: id ?? "")
            isAddedToFavourites = false
        }
        else{
            Favourites.shared.addItemToFavourites(item: meal ?? [:])
            isAddedToFavourites = true
        }
    }
    
    func getRecipeDetailData(meal: [String: String?]?) {
        guard let meal else { return }
        let id = meal["idMeal"] ?? ""
        if favourites?.contains(where: {$0["idMeal"] == id}) ?? false{
            isAddedToFavourites = true
        }
        else{
            isAddedToFavourites = false
        }
        if let name = meal["strMeal"] ?? "" {
            mealName = name
        }
        
        if let image = meal["strMealThumb"] ?? "" {
            mealImage = image
        }
        if let description = meal["strInstructions"] ?? "" {
            mealDescription = description
        }
        
        if let category = meal["strCategory"] ?? "" {
            mealCategory = category
        }
        
        if let cuisine = meal["strArea"] ?? "" {
            mealCuisine = cuisine
        }
        
        for i in 0..<meal.count {
            if let ingredient = meal["strIngredient\(i)"] ?? "", !ingredient.isEmpty,
               let measure = meal["strMeasure\(i)"] ?? "", !measure.isEmpty {
                ingredientList.append("\(ingredient) - \(measure)")
            }
        }
    }
}

