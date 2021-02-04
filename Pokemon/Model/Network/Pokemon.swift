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
        self = try JSONDecoder().decode(PokemonsListResponse.self, from: data)
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
    
    enum CodingKeys: String, CodingKey {
        case abilities
        case baseExperience = "base_experience"
        case forms
        case gameIndices = "game_indices"
        case height
        case heldItems = "held_items"
        case id
        case isDefault = "is_default"
        case locationAreaEncounters = "location_area_encounters"
        case moves
        case name
        case order
        case species
        case sprites
        case versions
        case stats
        case types
        case weight
    }
}

extension Pokemon: MappableResponse {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Pokemon.self, from: data)
    }
}

struct Version: Codable {
    
}

struct AbilityContent: Codable {
    var ability: BasicData
    var isHidden: Bool
    var slot: Int
    
    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
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
    
    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
        case other
    }
}

struct OtherSprites: Codable {
    var dreamWorld: DreamWorld?
    var officialArtwork: OfficialArtwork?
    
    enum CodingKeys: String, CodingKey {
        case dreamWorld = "dream_world"
        case officialArtwork = "official_artwork"
    }
}

struct DreamWorld: Codable {
    var frontDefault: String?
    var frontFemale: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontFemale = "front_female"
    }
}

struct OfficialArtwork: Codable {
    var frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct Move: Codable {
    var move: BasicData
    var versionGroupDetails: [VersionGroupDetails]
    
    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}

struct VersionGroupDetails: Codable {
    var levelLearnedAt: Int
    var moveLearnMethod: BasicData
    var versionGroup: BasicData
    
    enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
    }
}

struct Stat: Codable {
    var baseStat: Int
    var effort: Int
    var stat: BasicData
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
}

struct Type: Codable {
    var slot: Int
    var type: BasicData
}

struct Item: Codable {
    var item: BasicData
    var versionDetails: [VersionDetails]
    
    enum CodingKeys: String, CodingKey {
        case item
        case versionDetails = "version_details"
    }
}

struct VersionDetails: Codable {
    var rarity: Int
    var version: BasicData
}

struct Game: Codable {
    var gameIndex: Int
    var version: BasicData
    
    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version
    }
}

extension Pokemon {
    var allImages: [String] {
        [sprites.backDefault, sprites.backFemale, sprites.backShiny, sprites.backShinyFemale, sprites.frontDefault, sprites.frontFemale, sprites.frontShiny, sprites.frontShinyFemale, sprites.other?.dreamWorld?.frontDefault, sprites.other?.dreamWorld?.frontFemale, sprites.other?.officialArtwork?.frontDefault].compactMap { $0 }
    }
}
