//
//  Persistence.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/17.
//

import CoreData
import SwiftUI

struct PersistenceController {
    static public let shared = PersistenceController()
        
    let container: NSPersistentContainer
    
    init() {
        print("container 연결")
        container = NSPersistentContainer(name: "MoRI")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    public func addItem(_ viewContext: NSManagedObjectContext, _ albumArt: UIImage, _ title: String, _ singer: String, _ date: String, _ lyrics: String, _ cardColor: Color) {
        print("addItem start")
        let newItem = CardCD(context: viewContext)
        newItem.albumArt = uiImageToBinary(albumArt)
        newItem.title = title
        newItem.singer = singer
        newItem.date = date
        newItem.lyrics = lyrics
        newItem.cardColorR = cardColor.components.r
        newItem.cardColorG = cardColor.components.g
        newItem.cardColorB = cardColor.components.b
        newItem.cardColorA = cardColor.components.a

        do {
            try viewContext.save()
            print("save")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

extension PersistenceController {
    private func uiImageToBinary(_ uiImage: UIImage)->Data{
        guard let data = uiImage.pngData() else { fatalError("이미지 data 추출 에러") }
        return data
    }
}
