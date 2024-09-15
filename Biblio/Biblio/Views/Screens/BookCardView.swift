//
//  BookCardView.swift
//  Biblio
//
//  Created by dmoney on 9/15/24.
//

import SwiftUI


struct BookCardView: View {
    let book: Book
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let coverImage = book.coverImage {
                Image(uiImage: coverImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 150)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 200, height: 150)
                    .cornerRadius(12)
                    .overlay(
                        Image(systemName: book.type.iconName)
                            .foregroundColor(book.type.iconColor)
                            .font(.largeTitle)
                    )
            }


            Text(book.name)
                .font(.headline)


            Text("Author")
                .font(.caption)


            Button(action: onTap) {
                Label("Read Book", systemImage: "book")

            }
            .padding()



        }
        .frame(width: 200, height: 300)
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)

    }

}


