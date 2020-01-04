//
//  ViewController.swift
//  Project13
//
//  Created by Ayax Alexis Casarrubias Rodríguez on 10/12/19.
//  Copyright © 2019 Ayax Alexis. All rights reserved.
//

import UIKit
import CoreImage

var context: CIContext!
var currentFilter: CIFilter!

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = image
        //Creates a CIImage from a UIImage
        let beginImage = CIImage(image: currentImage)
        //This sends the CIImage to the Core Image Filter
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    var currentImage: UIImage!
    
    @IBAction func changeFilter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Error", message: "Theres no image in the currently selected", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing() //Its called as soon as the image is first imported
    }
    
    func applyProcessing() {
        //This checks if the filters support certain keys that can be modified like for example the intensity
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        
        guard let actionTitle = action.title else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        //In case theres an error when saving the image in the album
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved", message: "Your image has been succesfully saved", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        
    }
}

