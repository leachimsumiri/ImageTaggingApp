//
//  ViewController.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 06.01.22.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    let networking = Networking()
    
    @IBOutlet weak var imageTake: UIImageView!
    var imagePicker: UIImagePickerController!
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Take image
    @IBAction func takePhoto(_ sender: UIButton) {
        selectImageFrom(.camera)
    }
    
    @IBAction func chooseFromAlbum(_ sender: UIButton) {
        selectImageFrom(.photoLibrary)
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Saving Image here
    @IBAction func save(_ sender: AnyObject) {
        guard let selectedImage = imageTake.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        imageTake.image = selectedImage
        
        let imgBase64 = convertImageToBase64String(img: selectedImage)
        networking.uploadImage(imgBase64: imgBase64, completionHandler: { res, nserror in 
            print(res)
            print(nserror)
        })
        
        //1. save selectedImage
        //2. upload to imagga
        //curl --user "acc_8e641ff4617a004:f3c5e5919c1007d5e7e2d6268b245e28" -F "image=/Users/michaelirimus/Downloads/test.JPG" "https://api.imagga.com/v2/uploads"
        //3. validate response
        //4. list tags in tableview
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        let base64Img = img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
        //print(base64Img)
        return base64Img
    }
    
    func getImageData(image: UIImage) -> Data {
        //check file format
        return image.pngData()!//todo correct unwrap
        //status https://blog.devgenius.io/saving-images-in-coredata-8739690d0520
    }
}
