//
//  LanguageViewModel.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 20/09/22.
//

import Foundation

class LanguageViewModel {
    private var language: String?
    
    init(language: String) {
        self.language = "Language : \(language)"
    }
    
    func getLanguage() -> String {
        if let language = language {
            return language
        }
        return "Language : NA"
    }
}
