//
//  UploadViewController.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 06.01.22.
//

import UIKit
import CoreData

class UploadViewController: UIViewController, UINavigationControllerDelegate {
    let networking = Networking()
    
    var imagePicker: UIImagePickerController!
    
    @IBAction func takePhoto(_ sender: UIButton) {
        selectImageFrom(.camera)
    }
    @IBAction func chooseFromAlbum(_ sender: UIButton) {
        selectImageFrom(.photoLibrary)
    }
}

extension UploadViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            showAlertWith(title: "Error", message: "Image data could not be retrieved")
            return
        }
        
        guard let imageData = getImageData(image: selectedImage) else {
            return
        }
        
        let apiResponseViewController = self.storyboard?.instantiateViewController(withIdentifier: "ApiResponseViewController") as! ApiResponseViewController
        apiResponseViewController.image = imageData
        self.navigationController?.pushViewController(apiResponseViewController, animated: true)
    }
    
    
    func getImageData(image: UIImage) -> Data? {
        guard let imgData = image.pngData() else {
            showAlertWith(title: "Error", message: "Image data could not be retrieved")
            return nil
        }
        
        return imgData
    }
    
    func selectImageFrom(_ source: ImageSource) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
}

extension UIViewController {
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
