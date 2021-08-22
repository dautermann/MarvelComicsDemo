//
//  Response.swift
//  MarvelComicsDemo
//
//  Created by Michael Dautermann on 8/22/21.
//

import Foundation

struct ResponseFromServer : Decodable {
    let code: Int
    let status : String
    let copyright: String
    let attributionText: String
    let attributionHTML: String
    let etag: String
    let data: DataFromServer
//
//    enum CodingKeys: String, CodingKey {
//        case code, status, copyright, attributionText, attributionHTML, etag
//    }
}

struct DataFromServer : Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [Comic]

//    enum CodingKeys: String, CodingKey {
//        case offset, limit, total, count
//    }

}

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}

struct Comic : Decodable {
    let id: Int
    let digitalId: Int
    let title: String
    let issueNumber: Int
    let variantDescription: String
    let description: String?
    let modified: Date
    let isbn: String
    let upc: String
    let diamondCode: String
    let ean: String
    let issn: String
    let format: String
    let pageCount: Int
    let resourceURI: URL
    let images: [ComicImage]

    enum CodingKeys: String, CodingKey {
        case id, digitalId, title, issueNumber, variantDescription, description, modified, isbn, upc, diamondCode, ean, issn, format, pageCount,
             resourceURI, images
    }

}

struct ComicImage : Decodable {
    let path: String
    let pathExtension: String

    enum CodingKeys: String, CodingKey {
        case path, pathExtension = "extension"
    }
}
