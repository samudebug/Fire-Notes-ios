//
//  NoteEditor.swift
//  FIre Notes
//
//  Created by Samuel Martins on 26/10/23.
//

import SwiftUI
import MarkupEditor
import PhotosUI
import FirebaseAuth
struct NoteEditor: View {
    @EnvironmentObject var notesHelper: NotesHelper
    @Environment(\.dismiss) var dismiss
    @State var text: String = ""
    @State var title: String
    var id: String = "new"
    @State var content: String = ""
    @State var imageSelected: PhotosPickerItem? = nil
    @EnvironmentObject private var storageHelper: StorageHelper
    @State private var showError = false
    init(text: String = "", title: String = "", id: String = "new") {
        _text = State(initialValue: text)
        _title = State(initialValue: title)
        content = text
        self.id = id
        MarkupEditor.style = .compact
        let toolbar = ToolbarContents(
            insertContents: InsertContents(image: false)
        )
        ToolbarContents.custom = toolbar
    }
    var body: some View {
        VStack {
            TextField("Titulo", text: $title)
            MarkupEditorView(markupDelegate: self,html: $text, id: Date().ISO8601Format())
        }.toolbar {
            if id != "new" {
                Button {
                    guard let user = Auth.auth().currentUser?.uid else {
                        print("User not logged in")
                        return
                    }
                    let result = notesHelper.deleteNote(note: Note(id: id, title: title, content: content, uid: user))
                    if result {
                        dismiss()
                    } else {
                        showError = true
                    }
                } label: {
                    Image(systemName: "trash")
                }
            }
            Button {
                guard let user = Auth.auth().currentUser?.uid else {
                    print("User not logged in")
                    return
                }
                if id == "new" {
                    
                    let result = notesHelper.addNote(note: Note(title: title, content: content, uid: user))
                    if result {
                        dismiss()
                    } else {
                        showError = true
                    }
                } else {
                    let result = notesHelper.updateNote(note: Note(id: id, title: title, content: content, uid: user))
                    if result {
                        dismiss()
                    } else {
                        showError = true
                    }
                }
            } label: {
                Image(systemName: "square.and.arrow.down")
            }
            PhotosPicker( selection: $imageSelected,
                                matching: .images,
                          photoLibrary: .shared()){
                Image(systemName: "plus")
            }.onChange(of: imageSelected, initial: true) {
                if let imageSelected {
                    _ = handleImage(from: imageSelected)
                }
            }
        }.alert("An error has ocurred", isPresented: $showError) {
            Button("OK", role: .cancel) { showError = false }
        }
    }
    private func handleImage(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Data.self) {
            
            result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelected else {
                                print("Failed to get the selected item.")
                                return
                            }

                switch result {
                case .success(let imageData?):
                    let fileName = Date().ISO8601Format()
                    storageHelper.uploadImage(fileName:fileName, data: imageData) { url in
                        guard let downloadUrl = url else {
                            return;
                        }
                        guard let view = MarkupEditor.selectedWebView else { return }
                        content += "\n<img src=\"\(downloadUrl.absoluteString)\"></img>\n"
                        MarkupEditor.selectedWebView?.setHtml(content)
                        
                        
                    }
                    self.imageSelected = nil
                case .success(nil):
                    print("No Image")
                case .failure(let error):
                    print("Error \(error)")
                }
            }
        }
    }
    
    private func setRawText(_ handler: (()->Void)? = nil) {
            MarkupEditor.selectedWebView?.getHtml { html in
                self.content = html ?? ""
                handler?()
            }
        }
}

extension NoteEditor: MarkupDelegate {
    func markupError(code: String, message: String, info: String?, alert: Bool) {
        print("Markup error: \(message)")
    }
    func markupDidLoad(_ view: MarkupWKWebView, handler: (() -> Void)?) {
        MarkupEditor.selectedWebView = view
        setRawText(handler)
    }
    func markupInput(_ view: MarkupWKWebView) {
        setRawText()
    }
}


#Preview {
    NoteEditor()
}
