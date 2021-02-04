//
//  DataBaseManager.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/4/21.
//

import UIKit
import CoreData


class DataBaseManager {
    
    static let sharedManager = DataBaseManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Pokemon")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveContext () {
        let context = DataBaseManager.sharedManager.persistentContainer.viewContext
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
        let managedContext = DataBaseManager.sharedManager.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "PokemonsListObject", in: managedContext) else {
            return
        }
        
        results.forEach { (model) in
            let pokemonsListObject = PokemonsListObject(entity: entity, insertInto: managedContext)
            
            pokemonsListObject.name = model.name
            pokemonsListObject.url = model.url
            
            if let image = model.image {
                let data = image.jpegData(compressionQuality: 1)
                pokemonsListObject.image = data
            }
        }
        
        do {
            managedContext.mergePolicy = NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchPokemonsList() -> [PokemonsListObject]?{
        
        let managedContext = DataBaseManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PokemonsListObject")
        
        do {
            let pokemonsList = try managedContext.fetch(fetchRequest)
            return pokemonsList as? [PokemonsListObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func saveImage(for pokemonCellViewModel: PokemonCellViewModel) {
        
        let managedContext = DataBaseManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PokemonsListObject")
        
        fetchRequest.predicate = NSPredicate(format: "url = %@", pokemonCellViewModel.url)

        do {
            let pokemonsList = try managedContext.fetch(fetchRequest)
            
            guard let object = pokemonsList.first as? PokemonsListObject else { return }

            object.image = pokemonCellViewModel.image?.jpegData(compressionQuality: 1)

            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
