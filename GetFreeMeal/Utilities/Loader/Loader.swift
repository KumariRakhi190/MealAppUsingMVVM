//
//  Loader.swift
//  FreeMeal
//
//  Created by Rakhi Kumari on 15/09/24.
//

import SVProgressHUD

class Loader{
    
    static func show(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    }
    
    static func hide(){
        SVProgressHUD.dismiss()
    }
    
}

