//
//  DecodableComicsResponse.swift
//  MarvelComicsDemo
//
//  Created by Michael Dautermann on 8/22/21.
//

import Foundation

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
    let thumbnail: ComicImage?
    let images: [ComicImage]?

    enum CodingKeys: String, CodingKey {
        case id, digitalId, title, issueNumber, variantDescription, description, modified, isbn, upc, diamondCode, ean, issn, format, pageCount,
             resourceURI, thumbnail, images
    }

}

struct ComicImage : Decodable {
    let path: String
    let pathExtension: String

    enum CodingKeys: String, CodingKey {
        case path, pathExtension = "extension"
    }

    /// handy function to compose & return the whole path
    func wholePath() -> String {
        return path + "." + pathExtension
    }
}
