//
//  PhotoLibrary.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//


import Foundation
import SwiftUI
import UIKit
import PhotosUI

struct PhotoLibrary: UIViewControllerRepresentable{
    
    @Binding var isPresented: Bool
    @Binding var img: UIImage?
    
    static var isAvailable: Bool{
        UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        //nada
    }
    
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate{
        private var parent: PhotoLibrary
        
        init(_ parent: PhotoLibrary) {
            self.parent = parent
        }
        
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // unpack the selected items
            for image in results {
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
                        if let error = error {
                            print("Can't load image \(error.localizedDescription)")
                            self?.parent.img = nil
                        } else if let image = newImage as? UIImage {
                            // Add new image and pass it back to the main view
                            self?.parent.img = image
                        }
                    }
                } else {
                    print("Can't load asset")
                }
            }
            
            // close the modal view
            parent.isPresented = false
        }
        
        
        
        
        
    }
    
    
    
    
    
}
