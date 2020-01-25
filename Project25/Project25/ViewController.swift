//
//  ViewController.swift
//  Project25
//
//  Created by Ayax Alexis Casarrubias Rodríguez on 25/01/20.
//  Copyright © 2020 Ayax Alexis. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var images = [UIImage]()
    //MCPeerID identifies each user uniquely in a session.
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    //MCSession is the manager class that handles all multipeer connectivity for us.
    var mcSession: MCSession?
    //MCAdvertiserAssistant is used when creating a session, telling others that we exist and handling invitations.
    var mcAdvertiserAssistant: MCAdvertiserAssistant?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPromp))
        //peerID i used to create the sesion
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
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
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        //Check if there's an active session
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            //Convert the image into a Data object
            if let imageData = image.pngData() {
                //Send it to all peers and make sure it's delivered
                do {
                    //.reliable is used to ensure the data is sent intact to all peers
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    //If there's an error show a message
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    @objc func showConnectionPromp() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    //Because both methods are the result of an UIAction being tap, both must accept an UIAlertAction
    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws.project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    
    }
    //Finished sucessfully
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    //When user cancels
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    //When this method is called we'll be told what peer chanegd their state, and what is their new state
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    //When receiving the data from another device, it adds it to our images array
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
}

