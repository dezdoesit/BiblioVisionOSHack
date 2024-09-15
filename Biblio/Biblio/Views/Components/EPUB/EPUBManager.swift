////
////  EPUBManager.swift
////  Biblio
////
////  Created by Joanna Owczarek on 14/09/2024.
////
//
//import Foundation
//import EPUBKit
//
//class EPUBManager: ObservableObject {
//    @Published var document: EPUBDocument?
//    @Published var currentChapter: String = ""
//    
//    var pathToLabelDic: [String:String] = [:]
//    
//    var chapterSpineItems : [EPUBSpineItem] {
//        document?.spine.items.filter { $0.idref.contains("item")} ?? []
//    }
//
//    init(url: URL?) {
//        if let url = url {
//            loadEPUB(from: url)
//        } else {
//            //handle
//        }
//    }
//    
//    func loadEPUB(from url: URL) {
//        guard let epubDocument = EPUBDocument(url: url) else {
//            return
//        }
//        self.document = epubDocument
//        
//        var seenPaths = Set<String>()
//           
//        let pathToLabel: [(String, String)] = epubDocument.tableOfContents.subTable?.compactMap { tocItem in
//            guard let path = tocItem.item else { return nil }
//            let cleanedPath = cleanPath(path)
//            guard seenPaths.insert(cleanedPath).inserted else { return nil }
//            return (cleanedPath, tocItem.label)
//        } ?? []
//            
//        self.pathToLabelDic = Dictionary(uniqueKeysWithValues: pathToLabel)
//        
//        if let firstChapterId = chapterSpineItems.first?.idref,
//           let firstChapterPath = getPath(idref: firstChapterId) {
//            loadChapter(from: firstChapterPath)
//        }
//    }
//    
//    func getPath(idref: String) -> String? {
//        guard let document = document else { return nil}
//        return document.manifest.items[idref]?.path
//    }
//    
//    func cleanPath(_ path: String) -> String {
//        return path.components(separatedBy: "#").first ?? path
//    }
//    
//    func loadChapter(from path: String) {
//        guard let document = self.document else { return }
//        
//        if let chapterURL = document.contentDirectory.appendingPathComponent(cleanPath(path)) as URL? {
//            do {
//                let chapterContent = try String(contentsOf: chapterURL, encoding: .utf8)
//                self.currentChapter = chapterContent
//            } catch {
//                print("Error loading chapter: \(error)")
//            }
//        } else {
//            print("Invalid chapter URL")
//        }
//    }
//}
