import SwiftUI

struct DocumentRow: View {
    let document: Book

    var body: some View {
        HStack {
            Image(systemName: document.type.iconName)
                .foregroundColor(document.type.iconColor)
            VStack(alignment: .leading) {
                Text(document.name)
                    .font(.headline)
                HStack {
                    Text(document.type.displayName)
                    Text(document.size)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
    }
}
