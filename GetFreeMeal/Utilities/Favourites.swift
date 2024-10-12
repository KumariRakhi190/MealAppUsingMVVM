//
//  Favourites.swift
//  FreeMeal
//
//  Created by Rakhi Kumari on 15/09/24.
//

import Foundation

class Favourites{
    
    static let shared = Favourites()
    private let favouritesUserDefaultKey = "favouritesUserDefaultKey"
    
    private init(){}
    
    //MARK: function for getting the list of favourite items
    func getFavourites() -> [[String: String?]]?{
        let data = UserDefaults.standard.data(forKey: favouritesUserDefaultKey)
        return try? JSONDecoder().decode([[String: String?]].self, from: data ?? Data())
    }
    
    //MARK: function for adding the elements into favourite's list one by one.
    func addItemToFavourites(item: [String: String?]){
        var favourites = getFavourites() ?? []
        favourites.append(item)
        UserDefaults.standard.set(try? JSONEncoder().encode(favourites), forKey: favouritesUserDefaultKey)
    }
    
    //MARK: function for removing the elements form favourite one by one
    func removeItemFromFavourites(id: String){
        var favourites = getFavourites() ?? []
        favourites.removeAll { dict in
            dict["idMeal"] == id
        }
        UserDefaults.standard.set(try? JSONEncoder().encode(favourites), forKey: favouritesUserDefaultKey)
    }
    
    //MARK: function to delete all the favourites
    func removeAllFavourite() {
        UserDefaults.standard.removeObject(forKey: favouritesUserDefaultKey)
    }
    
}
