import Foundation
import Combine

class CategoryViewModel {
    @Published var categoriesOfMeal: [GetMealCategoryData]?
    @Published var errorMessage: String?
    var cancellables: Set<AnyCancellable> = []
    
    func getCategories(){
        APIManager.shared.apiRequest(type: GetMealCategoryModel.self, url: APIEndpoints.categories, httpMethodType: .get, parameter: nil){ success, myResponse, error, httpStatusCode in
            switch success {
            case true:
                if let response = myResponse {
                    self.categoriesOfMeal = response.categories
                }
            case false:
                self.errorMessage = error
            }
        
        }
    }
}
