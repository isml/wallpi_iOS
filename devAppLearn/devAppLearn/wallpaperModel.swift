// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let wallpaper = try? newJSONDecoder().decode(Wallpaper.self, from: jsonData)

import Foundation

// MARK: - Wallpaper
class Wallpaper: Codable {
    let page, perPage: Int
    let photos: [Photo]
    let totalResults: Int
    let nextPage: String

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case photos
        case totalResults = "total_results"
        case nextPage = "next_page"
    }

    init(page: Int, perPage: Int, photos: [Photo], totalResults: Int, nextPage: String) {
        self.page = page
        self.perPage = perPage
        self.photos = photos
        self.totalResults = totalResults
        self.nextPage = nextPage
    }
}

// MARK: - Photo
class Photo: Codable {
    let id, width, height: Int
    let url: String
    let photographer: String
    let photographerURL: String
    let photographerID: Int
    let avgColor: String
    let src: Src
    let alt: String

    enum CodingKeys: String, CodingKey {
        case id, width, height, url, photographer
        case photographerURL = "photographer_url"
        case photographerID = "photographer_id"
        case avgColor = "avg_color"
        case src, alt
    }

    init(id: Int, width: Int, height: Int, url: String, photographer: String, photographerURL: String, photographerID: Int, avgColor: String, src: Src, alt: String) {
        self.id = id
        self.width = width
        self.height = height
        self.url = url
        self.photographer = photographer
        self.photographerURL = photographerURL
        self.photographerID = photographerID
        self.avgColor = avgColor
        self.src = src
        self.alt = alt
    }
}

// MARK: - Src
class Src: Codable {
    let original, large2X, large, medium: String
    let small, portrait, landscape, tiny: String

    enum CodingKeys: String, CodingKey {
        case original
        case large2X = "large2x"
        case large, medium, small, portrait, landscape, tiny
    }

    init(original: String, large2X: String, large: String, medium: String, small: String, portrait: String, landscape: String, tiny: String) {
        self.original = original
        self.large2X = large2X
        self.large = large
        self.medium = medium
        self.small = small
        self.portrait = portrait
        self.landscape = landscape
        self.tiny = tiny
    }
}
