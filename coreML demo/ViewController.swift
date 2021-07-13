//
//  ViewController.swift
//  coreML demo
//
//  Created by Vivaan Baid on 08/07/21.
//

import UIKit
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.isEnabled = true
        image.isUserInteractionEnabled = true
        tap.addTarget(self, action: #selector(imagetapped(_:)))
        image.addGestureRecognizer(tap)

    }
    
    @objc
    private func imagetapped(_ gesture: UITapGestureRecognizer){
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        imagepicker.sourceType = .camera
        imagepicker.allowsEditing = true
        present(imagepicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selected_image = info[.editedImage] as? UIImage else {return}
        image.image = selected_image
        analyzeImage(image: selected_image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    
  
    
    
    private func analyzeImage(image: UIImage?){
        let resized = image?.resize(size: CGSize(width: 224, height: 224))
        let buffer = resized?.getCVPixelBuffer()
        
        //creating an instance of the model
        do{
            let config = MLModelConfiguration()
            let model = try GoogLeNetPlaces(configuration: config)
            let input = GoogLeNetPlacesInput(sceneImage: buffer!)
            
            let output = try model.prediction(input: input)
            let text = output.sceneLabel
            label.text = text
        }catch{
            print(error.localizedDescription)
        }
        
    }


}

