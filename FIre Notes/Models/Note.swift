//
//  Note.swift
//  FIre Notes
//
//  Created by Samuel Martins on 26/10/23.
//

import Foundation
import FirebaseFirestoreSwift
struct Note: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var content: String
    var uid: String
}
