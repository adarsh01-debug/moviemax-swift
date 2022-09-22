//
//  TitleViewModel.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 20/09/22.
//

import Foundation

class TitleViewModel {
    private var title: String?
    
    init(title: String) {
        self.title = title
    }
    
    func getTitle() -> String {
        return title ?? "NA"
    }
}
