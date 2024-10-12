import Foundation
import Combine

class HomeViewModel {
    @Published var homeRecipe: RandomMeal?
    @Published var randomMeal: RandomMeal?
    @Published var errorMessage: String?
    var searchUserWorkItemReference: DispatchWorkItem?
    var cancellable: Set<AnyCancellable> = []
    
    func getHomeRecipe(search: String) {
        APIManager.shared.apiRequest(type: RandomMeal.self, url: APIEndpoints.getHomeCategory, httpMethodType: .get, parameter: ["s": search]) { success, myResponse, error, httpStatusCode in
            switch success {
            case true:
                if let response = myResponse {
                    self.homeRecipe = response
                }
            case false:
                self.errorMessage = error
            }
        }
    }
    
    func getRandomMeal(){
        APIManager.shared.apiRequest(type: RandomMeal.self, url: APIEndpoints.randomMeal, httpMethodType: .get, parameter: nil) {success, myResponse, error, httpsStatusCode in
            switch success {
            case true:
                if let response = myResponse {
                    self.randomMeal = response
                }
            case false:
                self.errorMessage = error
            }
        }
    }
}
