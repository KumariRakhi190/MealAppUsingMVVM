//
//  APIEndpoints.swift
//  FreeMeal
//
//  Created by Rakhi Kumari on 15/09/24.
//

import Foundation

class APIEndpoints{
    
    private static let baseUrl = URL(string: "https://www.themealdb.com/api/json/v1/1/")!
    static let categories = baseUrl.appendingPathComponent("categories.php")
    static let randomMeal = baseUrl.appendingPathComponent("random.php")
    static let getHomeCategory = baseUrl.appendingPathComponent("search.php")
    static let mealsByCategory = baseUrl.appendingPathComponent("filter.php")
}

