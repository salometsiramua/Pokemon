//
//  ImageDownloader.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/2/21.
//

import Foundation

enum ImagePath {
    case backDefault
    case backFemale
    case backShiny
    case backShinyFemale
    case frontDefault
    case frontFemale
    case frontShinyFemale
    case dreamWorldFrontDefault
    case dreamWorldFrontFemale
    case offitialArtworkFrontDefault
    
    var type: String {
        switch self {
        case .dreamWorldFrontFemale, .dreamWorldFrontDefault:
            return ".svg"
        default:
            return ".png"
        }
    }
    
    var baseUrl: String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
    }
    
    var path: String? {
        switch self {
        case .backDefault:
            return "back/"
        case .backShiny:
            return "back/shiny/"
        case .offitialArtworkFrontDefault:
            return "other/official-artwork/"
        default:
            return nil
        }
    }
    
    func absoluteString(for index: String) -> String? {
        guard let path = path else { return nil }
        return "\(baseUrl)\(path)\(index)\(type)"
    }
}

protocol ImageDownloader {
    func download(for Index: String)
}

class ImageDownloaderService: ImageDownloader {
    
    func download(for index: String) {
        
    }
}
