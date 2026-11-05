//
//  AppStorageListExtension.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 4/11/2026.
//

import Foundation
import SwiftUI

// Credit: https://fatbobman.com/en/snippet/extending-supported-data-types-for-appstorage/
extension Array: @retroactive RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data) else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        return result
    }
}

