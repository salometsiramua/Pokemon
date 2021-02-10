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
    
    private func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(results: [PokemonCellViewModel]) {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        managedContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        
        guard let entity = NSEntityDescription.entity(forEntityName: "PokemonsListObject", in: managedContext) else {
            return
        }
        
        results.forEach { (model) in
            let pokemonsListObject = PokemonsListObject(entity: entity, insertInto: managedContext)
            
            pokemonsListObject.name = model.name
            pokemonsListObject.url = model.image.url
            
            if let image = model.image.image {
                let data = image.pngData()
                pokemonsListObject.image = data
            }
        }
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        managedContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PokemonsListObject")
        
        fetchRequest.predicate = NSPredicate(format: "url = %@", pokemonCellViewModel.url)

        do {
            let pokemonsList = try managedContext.fetch(fetchRequest)
            
            guard let object = pokemonsList.first as? PokemonsListObject else { return }

            object.image = pokemonCellViewModel.image.image?.pngData()
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

