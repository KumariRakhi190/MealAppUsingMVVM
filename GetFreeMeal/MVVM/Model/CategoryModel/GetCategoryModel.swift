//
//  GetCategoryModel.swift
//  FreeMeal
//
//  Created by Rakhi Kumari on 15/09/24.
//

import Foundation

// MARK: - GetMealCategoryModel
struct GetMealCategoryModel: Codable {
    let categories: [GetMealCategoryData]?
}

// MARK: - GetMealCategoryData
struct GetMealCategoryData: Codable {
    let idCategory, strCategory: String?
    let strCategoryThumb: String?
    let strCategoryDescription: String?
}
