//
//  StorageHelper.swift
//  FIre Notes
//
//  Created by Samuel Martins on 26/10/23.
//

import Foundation
import FirebaseStorage

final class StorageHelper:ObservableObject {
    var storage = Storage.storage()
    
    func uploadImage(fileName: String, data: Data, completion: @escaping (URL?) -> Void) {
        var storageRef = storage.reference()
        let fileRef = storageRef.child("images/\(fileName).png")
        let uploadTask = fileRef.putData(data) {
            (metadata, error) in
            guard let metadata = metadata else {
                print("Image upload failed!")
                return
            }
            fileRef.downloadURL { (url, error) in
                guard let downloadUrl = url else {
                    print("Get download url failed!")
                    completion(nil)
                    return
                }
                completion(downloadUrl)
            }
            
        }
    }
 }
