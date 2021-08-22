//
//  MD5.swift
//  MarvelComicsDemo
//
//  Created by Michael Dautermann on 8/15/21.
//

import CryptoKit

extension String {
    func md5() -> String {
        return Insecure.MD5.hash(data: self.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
    }
}
