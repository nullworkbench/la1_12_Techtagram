//
//  ViewController.swift
//  Techtagram
//
//  Created by nullworkbench on 2021/01/30.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var cameraImageView: UIImageView!
    
    var originalImage: UIImage!
    
    var filter: CIFilter!
    var filterIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        originalImage = info[.editedImage] as? UIImage
        
        cameraImageView.image = originalImage
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        } else {
            print("カメラが利用できません")
        }
    }
    
    @IBAction func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
    }
    
    @IBAction func colorFilter() {
        
        let filterArray:[[Double]] = [
            [1.0, 0.5, 2.5],
            [2.5, 0.3, 0.5],
            [0.5, 0.8, 1.0]
        ]
        
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        
        filter.setValue(filterArray[filterIndex][0], forKey: "inputSaturation")
        filter.setValue(filterArray[filterIndex][1], forKey: "inputBrightness")
        filter.setValue(filterArray[filterIndex][2], forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        
        cameraImageView.image = UIImage(cgImage: cgImage!)
        
        if filterIndex == 2 {
            filterIndex = 0
        } else {
            filterIndex += 1
        }
    }
    
    @IBAction func openAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func snsPhoto() {
        let shareText = "写真を加工したよ！"
        
        let shareImage = cameraImageView.image!
        
        let activityItems: [Any] = [shareText, shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
    }


}

