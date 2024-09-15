import SwiftUI

struct Book: Identifiable {
    let id = UUID()
    let bookmarkData: Data
    var coverImage: UIImage?

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

    var type: BookType {
        BookType(pathExtension: fileURL?.pathExtension ?? "unknown")
    }

    var size: String {
        guard let url = fileURL else { return "Unknown" }
        let bytes = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int64 ?? 0
        return ByteCountFormatter.string(fromByteCount: bytes ?? 0, countStyle: .file)
    }

    init(bookmarkData: Data) {
        self.bookmarkData = bookmarkData
        self.coverImage = Self.generateCoverImage(for: fileURL?.lastPathComponent ?? "Unknown")
    }

    private static func generateCoverImage(for title: String) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 160, height: 220))
        return renderer.image { ctx in
            let rect = CGRect(origin: .zero, size: CGSize(width: 160, height: 220))
            ctx.cgContext.setFillColor(UIColor.random().cgColor)
            ctx.cgContext.fill(rect)

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: UIColor.white
            ]

            let attributedString = NSAttributedString(string: title, attributes: attributes)
            attributedString.draw(with: rect.insetBy(dx: 10, dy: 10), options: .usesLineFragmentOrigin, context: nil)
        }
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
