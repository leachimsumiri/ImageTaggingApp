//
//  ViewController.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 06.01.22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let networking = Networking()
    var images:[Image]?
    
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
    
    //MARK: - Saving Image to photolibrary
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
        
        //saveImage(data: imageData)
        
        //MARK: - 1st Batch
        //1. select image or photo
        //2. upload to everypixel
        //curl --user "RmsP1fMKwriGr8NzNOxxuHdq:HaBGRbZXRIZBlQ9yCr9216McdThsVeyNPr3wUGwZ1pdc5BKl" -X POST -v -F "data=@/Users/michaelirimus/Downloads/person.png" "https://api.everypixel.com/v1/keywords?num_keywords=10" -v
        //3. validate response
        //4. save image and tags on success
        //5. list tags in tableview
        
        /*
         sample data response everypixel
         
         ["status": ok, "keywords": <__NSArrayI 0x6000022f3060>(
         {
             keyword = nature;
             score = "0.9963446367958373";
         },
         {
             keyword = leaf;
             score = "0.9923241836022356";
         },
         {
             keyword = plant;
             score = "0.9911774563872999";
         },
         {
             keyword = "multi colored";
             score = "0.9576665169633503";
         },
         {
             keyword = outdoors;
             score = "0.9495950604592167";
         },
         {
             keyword = flower;
             score = "0.9318137092904007";
         },
         {
             keyword = "close-up";
             score = "0.9301507381605739";
         },
         {
             keyword = summer;
             score = "0.9023457957607128";
         },
         {
             keyword = "beauty in nature";
             score = "0.8906225989201223";
         },
         {
             keyword = "pink color";
             score = "0.7430859512903449";
         }
         )
         ]
         */
    }
    
    func getImageData(image: UIImage) -> Data {
        //check file format
        return image.pngData()!//todo correct unwrap
        //return image.jpegData(compressionQuality: 1)!
        //status https://blog.devgenius.io/saving-images-in-coredata-8739690d0520
    }
    
    
    //CoreData
    func saveImage(data: Data) {
        //let entityName =  NSEntityDescription.entity(forEntityName: "Image", in: context)!
        //let image = NSManagedObject(entity: entityName, insertInto: context)
        //image.setValue(data, forKeyPath: "storedImage")
        
        let newImage = Image(context: self.context)
        newImage.storedImage = data
        
        do {
            try context.save()
            print("saved image!")
            //self.images?.append(newImage)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchImagesFromCoreData() {
        do {
            self.images = try context.fetch(Image.fetchRequest())
        } catch {
            print("error fetching images from CoreData")
        }
    }
}
