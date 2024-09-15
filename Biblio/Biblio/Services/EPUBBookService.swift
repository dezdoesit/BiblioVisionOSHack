//
//  EPUBBookService.swift
//  Biblio
//
//  Created by Joanna Owczarek on 15/09/2024.
//

import Foundation
import EPUBKit

struct EPUBBookService: BookServiceProtocol {
    
    let book: Book
    
    var document: EPUBDocument? {
        guard let url = book.fileURL else { return nil }
        guard let epubDocument = EPUBDocument(url: url) else { return nil }
        return epubDocument
    }
    
    var chapterSpineItems : [EPUBSpineItem] {
        document?.spine.items.filter { $0.idref.contains("item")} ?? []
    }
    
    init(book: Book) {
        self.book = book
    }
    
    func getPath(idref: String) -> String? {
        guard let document = document else { return nil}
        return document.manifest.items[idref]?.path
    }
    
    func cleanPath(_ path: String) -> String {
        return path.components(separatedBy: "#").first ?? path
    }
    
    func getBookContent() -> String? {
        guard let document = document else { return nil }
        var allContent = ""
        for spineItem in chapterSpineItems {
            if let path = getPath(idref: spineItem.idref),
               let chapterURL = document.contentDirectory.appendingPathComponent(cleanPath(path)) as URL? {
                do {
                    let chapterContent = try String(contentsOf: chapterURL, encoding: .utf8)
                    allContent += chapterContent + "\n\n"
                } catch {
                    print("Error loading chapter: \(error)")
                }
            }
        }
        return allContent
    }
    
    func getBookTitle() -> String? {
       return document?.title
    }
    
    func getChapters() -> [String] {
        guard let document = document else { return [] }
        var seenPaths = Set<String>()
        let pathToLabel: [(String, String)] = document.tableOfContents.subTable?.compactMap { tocItem in
            guard let path = tocItem.item else { return nil }
            let cleanedPath = cleanPath(path)
            guard seenPaths.insert(cleanedPath).inserted else { return nil }
            return (cleanedPath, tocItem.label)
        } ?? []
        
        let pathToLabelDic = Dictionary(uniqueKeysWithValues: pathToLabel)
        
        return chapterSpineItems.map { item in
            guard let path = getPath(idref: item.idref) else { return "Unknown" }
            return pathToLabelDic[path] ?? "Unknown"
        }
    }

}
