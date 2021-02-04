//
//  Image.swift
//  EulerityTakeHome
//
//  Created by Nick Nguyen on 2/2/21.
//

import UIKit

struct ImageObject: Codable {
  let url: String
}

struct UploadURL: Codable {
  let url: String
}

struct UploadingData: Encodable {
  let appid: String
  let original: String
  let file: Data 
}
