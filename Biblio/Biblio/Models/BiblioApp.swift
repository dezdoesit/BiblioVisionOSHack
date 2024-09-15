//
//  BiblioApp.swift
//  Biblio
//
//  Created by dmoney on 9/13/24.
//

import SwiftUI

@main
struct BiblioApp: App {
    @StateObject private var bookStore = BookStore()
    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
                .environmentObject(bookStore)
        }

        WindowGroup(id: "bookDetail", for: UUID.self) { $bookID in
                   BookDetailWindow()
                       .environmentObject(bookStore)
                       .environment(\.bookID, $bookID.wrappedValue)
               }
        
        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
