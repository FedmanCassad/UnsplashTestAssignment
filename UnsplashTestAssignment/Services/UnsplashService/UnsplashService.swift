//
//  UnsplashService.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import Alamofire
import UIKit

typealias PhotosModelResult = (Result<[UnsplashPhotoModel], ErrorDomain>) -> Void
typealias PhotosResult = (Result<[UIImage], ErrorDomain>) -> Void
typealias SearchResult = (Result<UnsplashSearchModel, ErrorDomain>) -> Void

protocol networkPhotoService {
    /// Used to get array of random photo models.
    func getRandomPhotosModels(ofCount count: Int?, completion:@escaping PhotosModelResult)


    /// Used to get array of photoModels found by keyword.
    func getPhotosByKeyword(keyword: String, completion: @escaping SearchResult)
}

final class UnsplashService: networkPhotoService {

    private enum DestinationURL: String {
        case randomPhotos = "https://api.unsplash.com/photos/random/"
        case searchPhotos = "https://api.unsplash.com/search/photos/"
    }

    enum UnsplashHeaders {
        case authorization

        private var stringHeader: String {
            switch self {
            case .authorization:
                return "Authorization"
            }
        }

       var headerValue: HTTPHeader {

            switch self {
            case .authorization:
                return HTTPHeader(name: "Authorization", value: "Client-ID O96Spakw8avR-LFa43K8CwxEOqYfh_y8MpKsedQj-DA")
            }
        }

    }

    func getRandomPhotosModels(ofCount count: Int? = 30, completion:@escaping PhotosModelResult) {
        let parameters: [String: String] = [
            "count": String(count ?? 1),
            "content_filter": "high"
        ]

        AF.request(
            DestinationURL.randomPhotos.rawValue,
            method: .get,
            parameters: parameters,
            encoder: .urlEncodedForm ,
            headers: [UnsplashHeaders.authorization.headerValue]
        ).responseData { response in
            guard let data = response.data else {
                completion(.failure(.failedToReceiveData))
                return }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            guard let photos = try? decoder.decode([UnsplashPhotoModel].self, from: data) else {
                completion(.failure(.jsonParseError))
                return
            }
            completion(.success(photos))
        }
    }

    func getPhotosByKeyword(keyword: String, completion: @escaping SearchResult) {
        let parameters: [String: String] = [
            "query": keyword,
            "per_page": "30"
        ]
        AF.request(
            DestinationURL.searchPhotos.rawValue,
            method: .get,
            parameters: parameters,
            encoder: .urlEncodedForm,
            headers: [UnsplashHeaders.authorization.headerValue]
        ).responseData { response in
            guard let data = response.data else {
                completion(.failure(.failedToReceiveData))
                return }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            guard let photosSearchResult = try? decoder.decode(UnsplashSearchModel.self, from: data) else {
                completion(.failure(.jsonParseError))
                return
            }
            completion(.success(photosSearchResult))
        }
    }
}


