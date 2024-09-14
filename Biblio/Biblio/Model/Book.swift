import SwiftUI

struct Book: Identifiable {
    let id = UUID()
    let bookmarkData: Data

    var fileURL: URL? {
        do {
            var isStale = false
            let url = try URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isStale)
            if isStale {
                // You might want to handle this case, perhaps by updating the bookmark
            }
            return url
        } catch {
            print("Error resolving bookmark: \(error)")
            return nil
        }
    }

    var name: String {
        fileURL?.lastPathComponent ?? "Unknown"
    }

    var type: String {
        fileURL?.pathExtension.uppercased() ?? "Unknown"
    }

    var size: String {
        guard let url = fileURL else { return "Unknown" }
        let bytes = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int64 ?? 0
        return ByteCountFormatter.string(fromByteCount: bytes ?? 0, countStyle: .file)
    }
}
