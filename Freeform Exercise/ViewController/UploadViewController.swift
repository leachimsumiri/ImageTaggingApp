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
        
        let mockResponse =
        """
            {
            "status": "ok",
            "keywords": [
                {
                    "keyword": "nature",
                    "score": 0.9963446367958373
                },
                {
                    "keyword" : "leaf",
                    "score" : 0.9923241836022356
                },
                {
                    "keyword" : "plant",
                    "score" : 0.9911774563872999
                },
                {
                    "keyword" : "multi colored",
                    "score" : 0.9576665169633503
                },
                {
                    "keyword" : "outdoors",
                    "score" : 0.9495950604592167
                }
            ]
        }
        """
        
        //temp
        let jsonDecoder = JSONDecoder()
        let apiResponse = try! jsonDecoder.decode(ApiResponse.self, from: mockResponse.data(using: .utf8)!)
        let keywords = apiResponse.keywords
        keywords.forEach { keyword in
            print("\(keyword.keyword) with score: \(keyword.score)")
        }
        
        let apiResponseViewController = self.storyboard?.instantiateViewController(withIdentifier: "ApiResponseViewController") as! ApiResponseViewController
        apiResponseViewController.keywords = keywords
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            // additional error handling
            return
        }
        apiResponseViewController.image = getImageData(image: selectedImage)
        self.navigationController?.pushViewController(apiResponseViewController, animated: true)
        
        // temp comment
        /*
         let imageData = getImageData(image: selectedImage)
         networking.uploadImage(imgData: imageData, completionHandler: { res, nserror in
         if let res = res {
         print("networking.uploadImage completionHandler: RES")
         print(res)
         }
         
         if let nserror = nserror {
         print("networking.uploadImage completionHandler: NSERROR")
         print(nserror)
         }
         })
         */
        
        //saveImage(data: imageData)
    }
    
    func getImageData(image: UIImage) -> Data {
        //check file format
        return image.pngData()!//todo correct unwrap
        //return image.jpegData(compressionQuality: 1)!
        
        // + errorHandling
        //status https://blog.devgenius.io/saving-images-in-coredata-8739690d0520
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
