//
//  ViewController.swift
//  Challenge4
//
//  Created by Ayax Alexis Casarrubias Rodríguez on 06/12/19.
//  Copyright © 2019 Ayax Alexis. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var images = [Image]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
       
        let defaults = UserDefaults.standard
        
        if let savedImages = defaults.object(forKey: "images") as? Data {
            let jsonDcoder = JSONDecoder()
            
            do {
                images = try jsonDcoder.decode([Image].self, from: savedImages)
            } catch {
                print("Failed to load images")
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let image = images[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = image.caption
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = images[indexPath.item]
        let ac = UIAlertController(title: "Caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let captions = ac?.textFields?[0].text else { return }
            image.caption = captions
        })
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController{
            vc.selectedImage = image.caption
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func addImage(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        let imageInfo = Image(caption: "Image", image: imageName)
        images.append(imageInfo)
        save()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(images) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "images")
        } else {
            print("Failed to save image")
        }
    }
  
}

