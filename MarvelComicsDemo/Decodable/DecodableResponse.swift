//
//  DecodableResponse.swift
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
}

struct DataFromServer : Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [Comic]
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
