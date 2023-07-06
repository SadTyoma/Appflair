//
//  DataManager.swift
//  Appflair
//
//  Created by Artem Shuneyko on 5.07.23.
//

import Foundation
import CoreData
import UIKit

class DataManager {

    static let shared = DataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CarModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    func fetchCars() -> [Car]? {
        let request: NSFetchRequest<CarEntity> = CarEntity.fetchRequest()
        do {
            let results = try persistentContainer.viewContext.fetch(request)
            return results.map { carEntity in
                Car(id: Int(carEntity.id), createdAt: carEntity.createdAt, brand: carEntity.brand ?? "", model: carEntity.model ?? "", description: carEntity.carDescription ?? "", images: carEntity.images?.components(separatedBy: " ") ?? [])
            }
        } catch let error {
            print("Error fetching cars: \(error.localizedDescription)")
            return nil
        }
    }

    func saveCars(_ cars: [Car]) {
        let context = persistentContainer.viewContext
        cars.forEach { car in
            let fetchRequest: NSFetchRequest<CarEntity> = CarEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", car.id)
            do {
                let results = try context.fetch(fetchRequest)
                if let existingCarEntity = results.first {
                    existingCarEntity.brand = car.brand
                    existingCarEntity.model = car.model
                    existingCarEntity.carDescription = car.description
                    existingCarEntity.images = car.images.joined(separator: " ")
                } else {
                    let carEntity = CarEntity(context: context)
                    carEntity.id = Int32(car.id)
                    carEntity.createdAt = car.createdAt
                    carEntity.brand = car.brand
                    carEntity.model = car.model
                    carEntity.carDescription = car.description
                    carEntity.images = car.images.joined(separator: " ")
                }
            } catch let error {
                print("Error fetching car: \(error.localizedDescription)")
            }
        }
        
        do {
            try context.save()
        } catch let error {
            print("Error saving cars: \(error.localizedDescription)")
        }
    }
}

class ImageCache {

    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func image(for key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }

    func save(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
