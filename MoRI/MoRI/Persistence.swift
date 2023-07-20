//
//  Persistence.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/17.
//

import CoreData
import SwiftUI

struct PersistenceController {
    static let shared = PersistenceController()
    
//    static var preview: PersistenceController = {
//        let result = PersistenceController()
//        let viewContext = result.container.viewContext
//        for _ in 0..<10 {
//            let newItem = Card(context: viewContext)
//            newItem.date = Date()
//            newItem.cardColorR = 0.1
//            newItem.cardColorG = 0.2
//            newItem.cardColorB = 0.3
//            newItem.textColorR = 1.1
//            newItem.textColorG = 1.2
//            newItem.textColorB = 1.3
//        }
//        do {
//            try viewContext.save()
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "MoRI")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func addItem(_ viewContext: NSManagedObjectContext, _ albumArt: String, _ title: String, _ singer: String, _ date: String, _ lyrics: String, _ cardColor: Color) {
        let newItem = Card(context: viewContext)
        newItem.albumArt = stringToBinary(albumArt)
        newItem.title = title
        newItem.singer = singer
        newItem.date = date
        newItem.lyrics = lyrics
        newItem.cardColorR = cardColor.components.r
        newItem.cardColorG = cardColor.components.g
        newItem.cardColorB = cardColor.components.b

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteItems(_ viewContext: NSManagedObjectContext, items: FetchedResults<Card>, offsets: IndexSet) {
        offsets.map { items[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func stringToBinary(_ str: String)->Data{
        let url = URL(string: str)!
        let data = try? Data(contentsOf: url)
        return data!
    }
}
