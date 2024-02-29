//
//  File.swift
//
//
//  Created by 13402598 on 30/01/2024.
//

import Foundation
import CoreData


public final class CoreDataDriver: IDataBaseDriver {
    
    public static let shared = CoreDataDriver()
    var context: NSManagedObjectContext!
    var psc : NSPersistentStoreCoordinator?
    
    
    private init() {
        self.initials()
    }
    
    
    private func initials() {
        guard let recource = Rumble.sdk.configuration?.coredataResource,
                let modelURL = Bundle.main.url(forResource: recource, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        
        guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Unable to resolve document directory")
        }
        let storeURL = docURL.appendingPathComponent("\(recource).sqlite")
        do {
            try psc?.addPersistentStore(ofType: NSSQLiteStoreType,
                                       configurationName: nil,
                                       at: storeURL,
                                       options: [NSMigratePersistentStoresAutomaticallyOption:true, NSInferMappingModelAutomaticallyOption:true])
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    
    private func fetchRequest<T>(_ type: T.Type, query: String?) -> NSFetchRequest<NSFetchRequestResult> {
        let entityName = String(describing: type)
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: entityName)
        if let query = query {
            request.predicate = NSPredicate.init(format: query)
        }
        return request
    }
    
    @discardableResult public func save<T>(_ entity: T) async -> Saved {
        guard let entity = entity as? NSManagedObject else { return Saved.init(value: false, error: "inavlid entity type") }
        
        do {
            try entity.managedObjectContext?.save()
            return Saved.init(value: true)
        } catch {
            return Saved.init(value: false, error: error.localizedDescription)
        }
    }
    
    @discardableResult public func save<T>(_ entities: [T]) async -> Saved {
        var session = [T]()
        var isError = false
        for entity in entities {
            let result = await self.save(entity)
            if !(result.value ?? false) {
                isError = true
                break
            }
            
            session.append(entity)
        }
        
        if isError {
            await self.deleteAll(session)
            return Saved.init(value: false, error: "Transaction has been rolled back.")
        }
        
        return Saved.init(value: true)
    }
    
    public func update<T>(_ entity: T, query: SQLQuery) async -> Saved {
        await save(entity)
    }
    
    func update<T>(_ entities: [T]) async -> Saved {
        await save(entities)
    }
    
    
    @discardableResult public func fetch<T>(_ type: T.Type, query: SQLQuery) async -> Fetched<[T]> {
        return await self._fetch(type, query: query.value)
    }
    
    @discardableResult public func fetch<T>(_ type: T.Type) async -> Fetched<[T]> {
        return await self._fetch(type)
    }
    
    
    @discardableResult public func delete<T>(_ entity: T) async -> Deleted {
        guard let entity = entity as? NSManagedObject else { return Deleted.init(value: false, error: "inavlid entity type") }
        entity.managedObjectContext?.delete(entity)
        return Deleted.init(value: true, error: nil)
    }
    
    @discardableResult func deleteAll<T>(_ entities: [T]) async -> Deleted {
        var deletedCount = 0
        for entity in entities {
            let result = await self.delete(entity)
            if result.value ?? false {
                deletedCount += 1
            }
        }
        return Deleted.init(value: deletedCount == entities.count, error: nil)
    }
    
    @discardableResult public func delete<T>(_ type: T.Type, query: SQLQuery) async -> Deleted {
        guard let items = await _fetch(type, query: query.value).value else { return Deleted.init(value: false, error: "unable to delete items")}
        return await deleteAll(items)
        
    }
}


fileprivate extension CoreDataDriver {
    func _fetch<T>(_ type: T.Type, query: String? = nil ) async -> Fetched<[T]> {
        do {
            let fetchRequest = self.fetchRequest(type, query: query)
            let items = try self.context.fetch(fetchRequest) as? [T] ?? []
            return Fetched.init(value: items, error: nil)
        } catch {
            return Fetched.init(error: error.localizedDescription)
        }
    }
}
