//
//  ViewController.swift
//  imageRecognition
//
//  Created by FAr Az on 11.07.24.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
        
    let model = try! VNCoreMLModel(for: MobileNetV2().model)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: functions
    
    @IBAction func selectImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            detectImageContent(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func detectImageContent(image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            if let results = request.results as? [VNClassificationObservation], let firstResult = results.first {
                DispatchQueue.main.async {
                    self.resultLabel.text = "\(firstResult.identifier) - \(Int(firstResult.confidence * 100))%"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: ciImage)
        try? handler.perform([request])
    }
}

