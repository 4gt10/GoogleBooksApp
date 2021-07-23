//
//  BooksListRouterInput.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

import Foundation

protocol BooksListRouterInput: AnyObject, AlertRoutable, URLRoutable, BookDetailsRoutable {

    func openFavorites()
}
