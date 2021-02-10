//
//  DataBaseManager.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/4/21.
//

import UIKit
import CoreData

protocol DataBaseManager {
    func save(results: [PokemonCellViewModel])
    func fetchPokemonsList() -> [PokemonsListObject]?
    func saveImage(for pokemonCellViewModel: PokemonCellViewModel)
}

final class CoreDataManager: DataBaseManager {
    
    static let sharedManager = CoreDataManager()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let newbackgroundContext = persistentContainer.newBackgroundContext()
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        newbackgroundContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        return newbackgroundContext
    }()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Pokemon")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func save(results: [PokemonCellViewModel]) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "PokemonsListObject", in: backgroundContext) else {
            return
        }
        
        results.forEach { (model) in
            let pokemonsListObject = PokemonsListObject(entity: entity, insertInto: backgroundContext)
            
            pokemonsListObject.name = model.name
            pokemonsListObject.url = model.url
            
            if let image = model.image.image {
                let data = image.pngData()
                pokemonsListObject.image = data
            }
        }
        
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    func fetchPokemonsList() -> [PokemonsListObject]?{
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PokemonsListObject")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "url", ascending: true)]
        
        do {
            let pokemonsList = try managedContext.fetch(fetchRequest)
            return pokemonsList as? [PokemonsListObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func saveImage(for pokemonCellViewModel: PokemonCellViewModel) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PokemonsListObject")
        fetchRequest.predicate = NSPredicate(format: "url = %@", pokemonCellViewModel.url)

        do {
            let pokemonsList = try backgroundContext.fetch(fetchRequest)
            guard let object = pokemonsList.first as? PokemonsListObject else { return }
            object.image = pokemonCellViewModel.image.image?.pngData()
            
            try backgroundContext.save()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
}

