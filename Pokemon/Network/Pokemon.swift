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
    var results: [PokemonBasicData]
}

struct PokemonBasicData: Codable {
    var name: String
    var url: String
}

extension PokemonsListResponse: MappableResponse {
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(PokemonsListResponse.self, from: data)
    }
}

struct Pokemon: Codable {
    var abilities: [Ability]
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
    var species: Species
    var sprites: Sprites
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
        case stats
        case types
        case weight
    }
}

struct Ability: Codable {
    
}

struct Form: Codable {
    
}

struct Species: Codable {
    
}

struct Sprites: Codable {
    
}

struct Move: Codable {
    
}

struct Stat: Codable {
    
}

struct Type: Codable {
    
}

struct Item: Codable {
    
}

struct Game: Codable {
    
}
