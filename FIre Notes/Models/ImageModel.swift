//
//  ImageModel.swift
//  FIre Notes
//
//  Created by Samuel Martins on 26/10/23.
//

import Foundation
import SwiftUI
import PhotosUI
import CoreTransferable

class ImageModel: ObservableObject {
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                _ = loadTransferable(from: imageSelection)
            }
        }
    }
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Image.self) {
            
            result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                                print("Failed to get the selected item.")
                                return
                            }

                switch result {
                case .success( _?):
                    print("Image")
                    self.imageSelection = nil
                case .success(nil):
                    print("No Image")
                case .failure(let error):
                    print("Error \(error)")
                }
            }
        }
    }
}
