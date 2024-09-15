//
//  EnvironmentKeys.swift
//  Biblio
//
//  Created by dmoney on 9/15/24.
//

import SwiftUI

private struct BookIDKey: EnvironmentKey {
    static let defaultValue: UUID? = nil
}

extension EnvironmentValues {
    var bookID: UUID? {
        get { self[BookIDKey.self] }
        set { self[BookIDKey.self] = newValue }
    }
}
