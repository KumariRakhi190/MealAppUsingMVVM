//
//  KeyboardStateManager.swift
//  FreeMeal
//
//  Created by Rakhi Kumari on 15/09/24.
//

import UIKit
import Foundation

final class KeyboardStateManager{
    
    static let shared = KeyboardStateManager()
    
    var isVisible = false
    var keyboardHeight: CGFloat = 0
    var observeKeyboardHeight: ((CGFloat) -> Void)?
    
    private init(){}
    
    func start(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleShow(_ notification: Notification){
        isVisible = true
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            observeKeyboardHeight?(keyboardHeight)
        }
    }
    
    @objc func handleHide(){
        isVisible = false
        observeKeyboardHeight?(0)
    }
    
    func stop(){
        NotificationCenter.default.removeObserver(self)
    }
    
}

