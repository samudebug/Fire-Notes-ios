//
//  NoteItem.swift
//  FIre Notes
//
//  Created by Samuel Martins on 26/10/23.
//

import SwiftUI

struct NoteItem: View {
    var note: Note
    var body: some View {
        VStack {
            Text(note.title).font(.title)
        }.frame(maxWidth: .infinity,maxHeight: 200).cornerRadius(8).padding()
    }
}

#Preview {
    NoteItem(note: Note(title: "Anotacao Legal", content: "Teste", uid: ""))
}
