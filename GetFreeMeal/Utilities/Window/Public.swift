//
//  Public.swift
//  FreeMeal
//
//  Created by Rakhi Kumari on 15/09/24.
//

import Foundation
import UIKit

func GetWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return sceneDelegate?.window ?? appDelegate?.window
    } else {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.window
    }
}
