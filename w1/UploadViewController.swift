//
//  UploadViewController.swift
//  Which1
//
//  Created by Theodore N. Sotiriou on 29/12/2016.
//  Copyright © 2016 Theodore N. Sotiriou. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var previewImage1: UIImageView!
    @IBOutlet var previewImage2: UIImageView!
    
    @IBOutlet var selectBtn1: UIButton!
    @IBOutlet var selectBtn2: UIButton!
    
    @IBOutlet var postBtn: UIButton!
    
    var picker2 = UIImagePickerController()
    var picker1 = UIImagePickerController()
    
    @IBOutlet var FilterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker1.delegate = self
        picker2.delegate = self
        
        FilterView.layer.cornerRadius = 5
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func animateFiltersIn(){
        self.view.addSubview(FilterView)
        FilterView.center = self.view.center
        
        FilterView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        FilterView.alpha = 0
        
        UIView.animate(withDuration: 0.4){
            self.FilterView.alpha = 1
            self.FilterView.transform = CGAffineTransform.identity
        }
    }
    
    func animateFiltersOut () {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.FilterView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.FilterView.alpha = 0
            
        }) {(success:Bool) in self.FilterView.removeFromSuperview()
        }
    }
    
    @IBAction func showFilters(_ sender: Any) {
        animateFiltersIn()
    }
    
    @IBAction func dismissFilters(_ sender: Any) {
        animateFiltersOut()
    }
    
    
    @IBAction func filterAView(_ sender: Any) {
        guard let image = self.previewImage1.image?.cgImage else {return}
        let openGLCeontext = EAGLContext (api: .openGLES3)
        let context = CIContext(eaglContext: openGLCeontext!)
        let ciImageA = CIImage(cgImage: image)
        let filter = CIFilter(name: "CIPhotoEffectChrome")
        filter?.setValue(ciImageA, forKey: kCIInputImageKey)
        //filter?.setValue(2, forKey: kCIInputIntensityKey)
        //filter?.setValue(2, forKey: kCIInputRadiusKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage{
            self.previewImage1.image = UIImage(cgImage: context.createCGImage(output, from: output.extent)!)
        }
    }
    
    @IBAction func filterA(_ sender: Any) {
        guard let image = self.previewImage1.image?.cgImage else {return}
        let openGLCeontext = EAGLContext (api: .openGLES3)
        let context = CIContext(eaglContext: openGLCeontext!)
        let ciImage = CIImage(cgImage: image)
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(1, forKey: kCIInputIntensityKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage{
            self.previewImage1.image = UIImage(cgImage: context.createCGImage(output, from: output.extent)!)
        }
    }
    
    @IBAction func filterB(_ sender: Any) {
        guard let image = self.previewImage1.image?.cgImage else {return}
        let openGLCeontext = EAGLContext (api: .openGLES3)
        let context = CIContext(eaglContext: openGLCeontext!)
        let ciImage = CIImage(cgImage: image)
        let filter = CIFilter(name: "CIFalseColor")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        //filter?.setValue(1, forKey: kCIInputIntensityKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage{
            self.previewImage1.image = UIImage(cgImage: context.createCGImage(output, from: output.extent)!)
        }
        
    }
    
    
    @IBAction func filterC(_ sender: Any) {
        guard let image = self.previewImage1.image?.cgImage else {return}
        let openGLCeontext = EAGLContext (api: .openGLES3)
        let context = CIContext(eaglContext: openGLCeontext!)
        let ciImage = CIImage(cgImage: image)
        let filter = CIFilter(name: "CIVignette")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(2, forKey: kCIInputIntensityKey)
        filter?.setValue(2, forKey: kCIInputRadiusKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage{
            self.previewImage1.image = UIImage(cgImage: context.createCGImage(output, from: output.extent)!)
        }
        
    }
    
    @IBAction func filterD(_ sender: Any) {
        guard let image = self.previewImage1.image?.cgImage else {return}
        let openGLCeontext = EAGLContext (api: .openGLES3)
        let context = CIContext(eaglContext: openGLCeontext!)
        let ciImage = CIImage(cgImage: image)
        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        //filter?.setValue(2, forKey: kCIInputIntensityKey)
        //filter?.setValue(2, forKey: kCIInputRadiusKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage{
            self.previewImage1.image = UIImage(cgImage: context.createCGImage(output, from: output.extent)!)
        }
        
    }
    
    

    @IBAction func filterAFade(_ sender: Any) {
        guard let image = self.previewImage1.image?.cgImage else {return}
        let openGLCeontext = EAGLContext (api: .openGLES3)
        let context = CIContext(eaglContext: openGLCeontext!)
        let ciImageAF = CIImage(cgImage: image)
        let filter = CIFilter(name: "CIPhotoEffectFade")
        filter?.setValue(ciImageAF, forKey: kCIInputImageKey)
        //filter?.setValue(2, forKey: kCIInputIntensityKey)
        //filter?.setValue(2, forKey: kCIInputRadiusKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage{
            self.previewImage1.image = UIImage(cgImage: context.createCGImage(output, from: output.extent)!)
        }
        
    }
    
    @IBAction func filterAChrome(_ sender: Any) {
        guard let image = self.previewImage1.image?.cgImage else {return}
        let openGLCeontext = EAGLContext (api: .openGLES3)
        let context = CIContext(eaglContext: openGLCeontext!)
        let ciImageAC = CIImage(cgImage: image)
        let filter = CIFilter(name: "CIPhotoEffectChrome")
        filter?.setValue(ciImageAC, forKey: kCIInputImageKey)
        //filter?.setValue(2, forKey: kCIInputIntensityKey)
        //filter?.setValue(2, forKey: kCIInputRadiusKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage{
            self.previewImage1.image = UIImage(cgImage: context.createCGImage(output, from: output.extent)!)
        }
        
    }
    
    

    
    
    @IBAction func sharedPressed(_ sender: Any) {
            let activityVC = UIActivityViewController(activityItems: [self.previewImage1.image, self.previewImage2.image], applicationActivities: nil)
            
        self.present(activityVC,animated:true, completion:nil)
        
    }

    @IBAction func select1Pressed(_ sender: Any) {
        picker1.allowsEditing = false
        picker1.sourceType = .photoLibrary
        self.present(picker1, animated: true, completion: nil)
    }
   
    @IBAction func select2Pressed(_ sender: Any) {
        picker2.allowsEditing = false
        picker2.sourceType = .photoLibrary
        self.present(picker2, animated: true, completion: nil)
    }
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //library photos
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as?  UIImage{
            if picker == picker1 {
                self.previewImage1.image = pickedImage
                self.selectBtn1.isEnabled=true
                self.selectBtn1.isHidden=false
                picker1.dismiss(animated: true, completion: nil)
            } else if picker == picker2    {
                self.previewImage2.image = pickedImage
                self.selectBtn2.isEnabled=true
                self.selectBtn2.isHidden=false
                picker2.dismiss(animated: true, completion: nil)
            }
        }
    }
   
    @IBAction func postPressed(_ sender: Any) {
        AppDelegate.instance().showActivityIndicator()
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        //let userImagePath = FIRAuth.auth()!.currentUser!.photoURL
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://neww1-ecc34.appspot.com")
        
        let key1 = ref.child("posts").childByAutoId().key
        let key2 = ref.child("posts").childByAutoId().key
        
        let imageRef1 = storage.child("posts").child(uid).child("\(key1).jpg")
        let imageRef2 = storage.child("posts").child(uid).child("\(key2).jpg")
        
        let data1 = UIImageJPEGRepresentation(self.previewImage1.image!, 0.6)
        let data2 = UIImageJPEGRepresentation(self.previewImage2.image!, 0.6)
        
        let uploadTask1 = imageRef1.put(data1!, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                AppDelegate.instance().dismissActivityIndicatos()
                return
            }
            
            imageRef1.downloadURL(completion: { (url, error) in
                if let url1 = url {
                    /*
                    let feed = ["userID" : uid,
                                "pathToImage1" : url.absoluteString,
                                "patheToImage2" :
                                "likes" : 0,
                                "author" : FIRAuth.auth()!.currentUser!.displayName!,
                                "postID" : key1] as [String : Any]
                    
                    let postFeed = ["\(key1)" : feed]
                    
                    ref.child("posts").updateChildValues(postFeed)
                    AppDelegate.instance().dismissActivityIndicatos()
                    
                    self.dismiss(animated: true, completion: nil)
                }
                */
            
            imageRef2.put(data2!, metadata: nil) { (metadata, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            AppDelegate.instance().dismissActivityIndicatos()
                            return
                        }
            
            imageRef2.downloadURL(completion: { (url, error) in
                if let url2 = url {
                    let feed = ["userID" : uid,
                                "pathToImage1" : url1.absoluteString,
                                "pathToImage2" : url2.absoluteString,
                                "likes1" : 0,
                                "likes2" : 0,
                                "author" : FIRAuth.auth()!.currentUser!.displayName!,
                                //"userImage" : userImagePath,
                                "postID" : key2] as [String : Any]
                    
                    let postFeed = ["\(key2)" : feed]
                    
                    ref.child("posts").updateChildValues(postFeed)
                    AppDelegate.instance().dismissActivityIndicatos()
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
            })
            
            
        }
                }})
        
            
        }
        
        uploadTask1.resume()
        
    
        
    
    /*
        let uploadTask2 = imageRef2.put(data2!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                AppDelegate.instance().dismissActivityIndicatos()
                return
            }
            
            imageRef2.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userID" : uid,
                                "pathToImage" : url.absoluteString,
                                "likes" : 0,
                                "author" : FIRAuth.auth()!.currentUser!.displayName!,
                                "postID" : key2] as [String : Any]
                    
                    let postFeed = ["\(key2)" : feed]
                    
                    ref.child("posts").updateChildValues(postFeed)
                    AppDelegate.instance().dismissActivityIndicatos()
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        }
        
        uploadTask2.resume()

        
    }
 */
    }
}
