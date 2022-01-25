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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension UploadViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        
        guard let imageData = getImageData(image: selectedImage) else {
            return
        }
        
        networking.uploadImage(imgData: imageData, completionHandler: { keywords in
            if let keywords = keywords {
                let apiResponseViewController = self.storyboard?.instantiateViewController(withIdentifier: "ApiResponseViewController") as! ApiResponseViewController
                apiResponseViewController.keywords = keywords
                apiResponseViewController.image = imageData
                self.navigationController?.pushViewController(apiResponseViewController, animated: true)
            }
        })
    }
    
    func getImageData(image: UIImage) -> Data? {
        //check file format
        guard let imgData = image.pngData() else {
            print("Image data could not be retrieved")
            return nil
        }
        
        return imgData
        //return image.jpegData(compressionQuality: 1)!
    }
    
    func selectImageFrom(_ source: ImageSource){
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
    
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
