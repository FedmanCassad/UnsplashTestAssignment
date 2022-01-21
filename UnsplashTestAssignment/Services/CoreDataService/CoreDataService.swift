//
//  CoreDataService.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 20.01.2022.
//

import CoreData

protocol DataProviderFacadeProtocol {
    func savePhotoModel(_ model: UnsplashPhotoModel)
    func fetchSavedPhotoModels() -> [CDPhoto]?
    func getSpecificPhoto(byID id: String) -> CDPhoto?
    func deleteSpecificPhotoFromFavorites(byPhotoId id: String)
}

final class CoreDataService {
    private let modelName: String
    private let container: NSPersistentContainer
    private var context: NSManagedObjectContext!
    private var taskContext: NSManagedObjectContext!

    static let shared = CoreDataService(dataModelName: "Favorites")


    private init(dataModelName: String) {
        self.modelName = dataModelName
        self.container = NSPersistentContainer(name: dataModelName)
        setupStack()
    }

    func setupStack() {
        container.loadPersistentStores {[weak self] _, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self?.context = self?.container.viewContext
                self?.taskContext = self?.container.newBackgroundContext()
                self?.taskContext.mergePolicy = NSMergePolicy.overwrite
            }
        }
    }

    func save() {
        taskContext.perform {
            if self.taskContext.hasChanges {
                do {
                    try self.taskContext.save()
                } catch {
                    self.taskContext.rollback()
                }
            }
        }
    }

    func createObject<T: NSManagedObject>() -> T {
        guard let name = T.entity().name,
              let object = NSEntityDescription.insertNewObject(forEntityName: name, into: taskContext) as? T
        else {
            fatalError("Cannot insert object")
        }
        return object
    }

    func deleteObject<T: NSManagedObject> (object: T) {
        taskContext.delete(object)
        save()
    }

    func fetchData<T: NSManagedObject> (
        for entity: T.Type,
        withPredicate predicate: NSCompoundPredicate? = nil,
        withSortDescriptor sortDescriptors: [NSSortDescriptor]? = nil
    ) -> [T]? {
        let request: NSFetchRequest<T>
        var fetchedResult = [T]()
        request = NSFetchRequest(entityName: String(describing: entity))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        do {
            fetchedResult = try taskContext.fetch(request)
        } catch {
            debugPrint("Error occurred: \(error.localizedDescription)")
        }
        return fetchedResult
    }
}

extension CoreDataService: DataProviderFacadeProtocol {

    func savePhotoModel(_ model: UnsplashPhotoModel) {
        let object: CDPhoto = createObject()
        object.prepareFromCodablePhotoModel(model)
        save()
    }

    func fetchSavedPhotoModels() -> [CDPhoto]? {
        let photos: [CDPhoto]? = fetchData(
            for: CDPhoto.self, withSortDescriptor: [NSSortDescriptor(key: "author", ascending: true)]
        )
        return photos
    }

    func getSpecificPhoto(byID id: String) -> CDPhoto? {
        let predicate = getPhotoPredicate(by: id)
        return fetchData(
            for: CDPhoto.self,
               withPredicate: NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
        )?.first
    }

    func deleteSpecificPhotoFromFavorites(byPhotoId id: String) {
        guard let object = getSpecificPhoto(byID: id) else { return }
        deleteObject(object: object)
    }

    private func getPhotoPredicate(by photoID: String) -> NSPredicate {
        NSPredicate(format: "id CONTAINS[c] %@", photoID)
    }
}
