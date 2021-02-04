//
//  Pockemon.swift
//  Pockemon
//
//  Created by Salome Tsiramua on 02.02.21.
//

import Foundation

struct PokemonsListResponse: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokemonsBasicData]
}

struct PokemonsBasicData: Codable {
    var name: String
    var url: String
}

extension PokemonsListResponse: MappableResponse {
    
    init(data: Data) throws {
        self = try JSONDecoder.decoderWithSnakeCaseConverter.decode(PokemonsListResponse.self, from: data)
    }
}

struct Pokemon: Codable {
    var abilities: [AbilityContent]
    var baseExperience: Int
    var forms: [Form]
    var gameIndices: [Game]
    var height: Int
    var heldItems: [Item]
    var id: Int
    var isDefault: Bool
    var locationAreaEncounters: String
    var moves: [Move]
    var name: String
    var order: Int
    var species: BasicData
    var sprites: Sprites
    var versions: [Version]?
    var stats: [Stat]
    var types: [Type]
    var weight: Int
}

extension Pokemon: MappableResponse {
    init(data: Data) throws {
        self = try JSONDecoder.decoderWithSnakeCaseConverter.decode(Pokemon.self, from: data)
    }
}

struct Version: Codable {
    
}

struct AbilityContent: Codable {
    var ability: BasicData
    var isHidden: Bool
    var slot: Int
}

struct BasicData: Codable {
    var name: String
    var url: String
}

struct Form: Codable {
    
}

struct Sprites: Codable {
    var backDefault: String?
    var backFemale: String?
    var backShiny: String?
    var backShinyFemale: String?
    var frontDefault: String?
    var frontFemale: String?
    var frontShiny: String?
    var frontShinyFemale: String?
    var other: OtherSprites?
}

struct OtherSprites: Codable {
    var dreamWorld: DreamWorld?
    var officialArtwork: OfficialArtwork?
}

struct DreamWorld: Codable {
    var frontDefault: String?
    var frontFemale: String?
}

struct OfficialArtwork: Codable {
    var frontDefault: String?
}

struct Move: Codable {
    var move: BasicData
    var versionGroupDetails: [VersionGroupDetails]
}

struct VersionGroupDetails: Codable {
    var levelLearnedAt: Int
    var moveLearnMethod: BasicData
    var versionGroup: BasicData
}

struct Stat: Codable {
    var baseStat: Int
    var effort: Int
    var stat: BasicData
}

struct Type: Codable {
    var slot: Int
    var type: BasicData
}

struct Item: Codable {
    var item: BasicData
    var versionDetails: [VersionDetails]
}

struct VersionDetails: Codable {
    var rarity: Int
    var version: BasicData
}

struct Game: Codable {
    var gameIndex: Int
    var version: BasicData
}

extension Pokemon {
    var allImages: [String] {
        [sprites.backDefault, sprites.backFemale, sprites.backShiny, sprites.backShinyFemale, sprites.frontDefault, sprites.frontFemale, sprites.frontShiny, sprites.frontShinyFemale, sprites.other?.dreamWorld?.frontDefault, sprites.other?.dreamWorld?.frontFemale, sprites.other?.officialArtwork?.frontDefault].compactMap { $0 }
    }
}

extension JSONEncoder {
    public static var encoderWithSnakeCaseConverter: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}

extension JSONDecoder {
    public static var decoderWithSnakeCaseConverter: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
