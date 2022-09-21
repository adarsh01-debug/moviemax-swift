//
//  TitleViewModel.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 20/09/22.
//

import Foundation
import UIKit

class TitleViewModel {
    private var title: String?
    
    init(title: String) {
        self.title = title
    }
    
    func getTitle() -> String {
        if let title = title {
            return title
        }
        return "NA"
    }
}
