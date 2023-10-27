//
//  NotesList.swift
//  FIre Notes
//
//  Created by Samuel Martins on 26/10/23.
//

import SwiftUI
struct NotesList: View {
    @EnvironmentObject var notesHelper: NotesHelper
    @EnvironmentObject var authHelper: AuthHelper
    var body: some View {
        VStack {
            if (notesHelper.notes.isEmpty) {
                Text("No items")
            } else {
                List {
                    ForEach(notesHelper.notes) { note in
                        NavigationLink {
                            NoteEditor(text: note.content, title: note.title, id: note.id!)
                        } label: {
                            NoteItem(note: note)
                        }.swipeActions {
                            Button {
                                notesHelper.deleteNote(note: note)
                                notesHelper.fetchNotes()
                            } label: {
                                Image(systemName: "delete.left")
                            }.tint(.red)
                        }
                    }
                    
                }.listStyle(PlainListStyle())
            }
        }.navigationTitle("Notes").onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                notesHelper.fetchNotes()
            }
        }.toolbar {
            NavigationLink {
                NoteEditor()
            } label: {
                Image(systemName: "plus")
            }
            Button {
                authHelper.signOut()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
            }
        }
    }
}

#Preview {
    NotesList().environmentObject(NotesHelper()).environmentObject(AuthHelper())
}
