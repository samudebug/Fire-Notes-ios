//
//  NoteHelpers.swift
//  FIre Notes
//
//  Created by Samuel Martins on 26/10/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
final class NotesHelper: ObservableObject {
    @Published var notes: [Note] = []
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    func fetchNotes() {
        guard let user = auth.currentUser?.uid else {
            print("User not logged in")
            return
        }
        db.collection("notes").whereField("uid", isEqualTo: user).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error fetching documents: ")
                } else {
                    self.notes = querySnapshot!.documents.map {
                        do {
                            return try $0.data(as: Note.self)
                        } catch {
                            fatalError("Unable to load notes: \(error)")
                        }
                    }
                }
            }
        
    }
    
    func addNote(note: Note) -> Bool {
        do {
            try db.collection("notes").addDocument(from: note)
            return true
        } catch {
            print("error while adding document: \(error)")
            return false
        }
    }
    
    func updateNote(note: Note) -> Bool {
        if let id = note.id {
            let docRef = db.collection("notes").document(id)
            do {
                try docRef.setData(from: note)
                return true
            } catch {
                print("error while updating document: \(error)")
                return false
            }
        }
        return false
    }
    
    func deleteNote(note: Note) -> Bool {
        if let id = note.id {
            let docRef = db.collection("notes").document(id)
            do {
                try docRef.delete()
                return true
            } catch {
                print("Error while deleting document: \(error)")
                return false
            }
        }
        return false
    }
}
