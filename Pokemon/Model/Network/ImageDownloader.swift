//
//  ImageDownloader.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/2/21.
//

import UIKit

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

class PendingOperations {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
}

enum ImageState {
    case new
    case downloaded
    case failed
}

class Image {
    let url: String?
    var state = ImageState.new
    var image: UIImage?
    
    init(url: String?, image: UIImage? = nil) {
        self.url = url
        self.image = image
    }
}

class ImageDownloader: Operation {
    
    let image: Image
    let indexPath: IndexPath
    
    init(_ image: Image, indexPath: IndexPath) {
        self.image = image
        self.indexPath = indexPath
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        guard let url = image.url, let imageUrl = URL(string: url), let imageData = try? Data(contentsOf: imageUrl) else {
            image.state = .failed
            return
        }
        
        image.image = imageData.isEmpty ? nil : UIImage(data: imageData)
        image.state = image.image == nil ? .failed : .downloaded
    }
}
