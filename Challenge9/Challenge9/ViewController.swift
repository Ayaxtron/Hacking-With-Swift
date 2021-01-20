//
//  ViewController.swift
//  Challenge9
//
//  Created by Ayax Alexis Casarrubias Rodríguez on 19/01/21.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    
    @IBAction func setTopText(_ sender: Any) {
        let ac = UIAlertController(title: "Enter some text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let textField = ac.textFields?[0].text else { return }
            self?.topText = textField
            self?.generateMeme()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
        
    }
    
    @IBAction func setBottomText(_ sender: Any) {
        let ac = UIAlertController(title: "Enter some text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let textField = ac.textFields?[0].text else { return }
            self?.botText = textField
            self?.generateMeme()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }
    
    var image: UIImage!
    var topText = ""
    var botText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(pickImage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
    }

    @objc func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imagePicked = info[.editedImage] as? UIImage  else { return }
        //imageView.image = imagePicked
        image = imagePicked
        generateMeme()
        dismiss(animated: true)
    }
    
    func generateMeme() {
        guard image != nil else { return }
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let img = renderer.image { ctx in
            
            let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            image.draw(in: rect)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 40),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.red
            ]
            
            let attributedStringTop = NSAttributedString(string: topText, attributes: attrs)
            let attributedStringBot = NSAttributedString(string: botText, attributes: attrs)
            
            attributedStringTop.draw(with: CGRect(x: 70, y: 20, width: 400, height: 150), options: .usesLineFragmentOrigin, context: nil)
            attributedStringBot.draw(with: CGRect(x: 70, y: 300, width: 400, height: 150), options: .usesLineFragmentOrigin, context: nil)
            
        }
        imageView.image = img
    }
    
    @objc func shareImage() {
        guard let image = self.image.jpegData(compressionQuality: 0.8) else {
            print("Image not found")
            return }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(vc, animated: true)
    }
}

