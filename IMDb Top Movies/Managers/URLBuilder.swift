//
//  URLBuilder.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import Foundation

protocol URLBuilderProtocol {
    func buildTopMoviesURL() -> URL?
    func buildImageResizeURL(imageURL: String) -> URL?
}

class URLBuilder: URLBuilderProtocol {
    
    static var shared = URLBuilder()
    
    private struct Constants {
        static let stringURL = "https://imdb-api.com/API/"
        static let lang = "en"
        static let apiKey = "k_12qh7df3"
        static let topMoviesApiPath = "Top250Movies"
        static let resizeImageApiPath = "ResizeImage"
        static let imageSize = "390x550"
        
        static let apiKeyPath = "apikey"
        static let langPath = "lang"
        static let urlPath = "url"
        static let sizePath = "size"
    }
    
    func buildTopMoviesURL() -> URL? {
        let url = Constants.stringURL + Constants.topMoviesApiPath
        var components = getURLComponents(for: url)
        components?.queryItems?.append(URLQueryItem(name: Constants.langPath, value: Constants.lang))
        return components?.url
    }
    
    func buildImageResizeURL(imageURL: String) -> URL? {
        let url = Constants.stringURL + Constants.resizeImageApiPath
        var components = getURLComponents(for: url)
        components?.queryItems?.append(URLQueryItem(name: Constants.urlPath, value: imageURL))
        components?.queryItems?.append(URLQueryItem(name: Constants.sizePath, value: Constants.imageSize))
        return components?.url
    }
    
    private func getURLComponents(for url: String) -> URLComponents? {
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = [
            URLQueryItem(name: Constants.apiKeyPath, value: Constants.apiKey)
        ]
        return urlComponents
    }
}
