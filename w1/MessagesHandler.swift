//
//  MessagesHandler.swift
//  Which1
//
//  Created by Theodore N. Sotiriou on 11/04/2017.
//  Copyright © 2017 Theodore N. Sotiriou. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase


protocol MessageReceivedDelegate: class {
    func messageReceived(senderID: String, senderName: String, text: String);
    func mediaReceived(senderID: String, senderName: String, url: String);
}

class MessagesHandler {
    private static let _instance = MessagesHandler();
    private init() {}
    
    weak var delegate: MessageReceivedDelegate?;
    
    static var Instance: MessagesHandler {
        return _instance;
    }
    
    func sendMessage(senderID: String, senderName: String, text: String) {
        
        let data: Dictionary<String, Any> = ["sender_id": senderID, "sender_name": senderName, "text": text];
        
        FIRDatabase.database().reference().child("Messages").childByAutoId().setValue(data);
        
    }
    
    func sendMediaMessage(senderID: String, senderName: String, url: String) {
        let data: Dictionary<String, Any> = ["sender_id": senderID, "sender_name": senderName, "url": url];
        
        FIRDatabase.database().reference().child("Media_Messages").childByAutoId().setValue(data);
    }
    
    func sendMedia(image: Data?, video: URL?, senderID: String, senderName: String) {
        
        if image != nil {
            
            FIRStorage.storage().reference(forURL: "gs://which1-93cb6.appspot.com").child("Image_Storage").child(senderID + "\(NSUUID().uuidString).jpg").put(image!, metadata: nil) { (metadata: FIRStorageMetadata?, err: Error?) in
                
                if err != nil {
                    // inform the user that there was a problem uploading his image
                } else {
                    self.sendMediaMessage(senderID: senderID, senderName: senderName, url: String(describing: metadata!.downloadURL()!));
                }
                
            }
            
        } else {
            FIRStorage.storage().reference(forURL: "gs://which1-93cb6.appspot.com").child("Video_Storage").child(senderID + "\(NSUUID().uuidString)").putFile(video!, metadata: nil) { (metadata: FIRStorageMetadata?, err: Error?) in
                
                if err != nil {
                    // inform the user that uploading the video has failed using delegation
                } else {
                    self.sendMediaMessage(senderID: senderID, senderName: senderName, url: String(describing: metadata!.downloadURL()!))
                }
                
            }
        }
        
    }
    
    func observeMessages() {
        FIRDatabase.database().reference().child("Messages").observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let senderID = data["sender_id"] as? String {
                    if let senderName = data["sender_name"] as? String {
                        if let text = data["text"] as? String {
                            self.delegate?.messageReceived(senderID: senderID, senderName: senderName, text: text);
                        }
                    }
                }
            }
            
        }
    }
    
    func observeMediaMessages() {
        FIRDatabase.database().reference().child("Media_Messages").observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let id = data["sender_id"] as? String {
                    if let name = data["sender_name"] as? String {
                        if let fileURL = data["url"] as? String {
                            self.delegate?.mediaReceived(senderID: id, senderName: name, url: fileURL);
                        }
                    }
                }
            }
            
        }
    }
    
    
} // class
