//
//  EncodableExtension.swift
//  HouseRizz-iOS
//
//  Created by Krish Mittal on 02/06/24.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any]{
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}

extension Decodable {
    static func asObject(from dict: [String: Any]) -> Self? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
            let object = try JSONDecoder().decode(Self.self, from: data)
            return object
        } catch {
            print("Failed to decode JSON to \(Self.self):", error)
            return nil
        }
    }
}
