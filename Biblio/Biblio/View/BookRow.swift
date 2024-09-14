import SwiftUI

struct DocumentRow: View {
    let document: Book

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
            VStack(alignment: .leading) {
                Text(document.name)
                    .font(.headline)
                HStack {
                    Text(document.type)
                    Text(document.size)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
    }

    private var iconName: String {
        switch document.type {
        case "PDF":
            return "doc.fill"
        case "EPUB":
            return "book.fill"
        default:
            return "doc"
        }
    }

    private var iconColor: Color {
        switch document.type {
        case "PDF":
            return .red
        case "EPUB":
            return .green
        default:
            return .gray
        }
    }
}
