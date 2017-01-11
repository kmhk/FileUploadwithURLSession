//
//  ViewController.swift
//  FileUpload
//
//  Created by Com on 11/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {

	@IBOutlet weak var txtURL: UITextField!
	
	var image: UIImage?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	@IBAction func uploadButtonTap(_ sender: Any) {
		guard image != nil else { return }
		guard txtURL.text != "" else { return }
		
		let url = URL(string: txtURL.text!)
		var request = URLRequest(url: url!)
		
		request.httpMethod = "POST"
		
		/*
			add header
		*/
		let boundary = "---------------------------14737809831466499882746641449"
		let contentTypeValue = String(format: "multipart/form-data; boundary=%@", boundary)
		
		request.addValue(contentTypeValue, forHTTPHeaderField: "Content-Type")
		
		/*
			add body
		*/
		let bodyData = NSMutableData()
		
		bodyData.append(String(format: "\r\n--%@\r\n", boundary).data(using: .utf8)!)
		bodyData.append(String(format: "Content-Disposition: form-data; name=\"user_icon\"; filename=").data(using: .utf8)!)
		bodyData.append(String(format: "image.jpg\r\n").data(using: .utf8)!)
		bodyData.append(String(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: .utf8)!)
		bodyData.append(UIImageJPEGRepresentation(image!, 0.5)!)
		bodyData.append(String(format: "\r\n--%@--\r\n", boundary).data(using: .utf8)!)
		
		request.httpBody = bodyData as Data
		
		/*
			send data
		*/
		let task = URLSession.shared.dataTask(with: request) {data, response, err in
			print("uploading is finished")
		}
		task.resume()
	}
	
	
	@IBAction func importButtonTap(_ sender: Any) {
		let picker = UIImagePickerController()
		picker.sourceType = .photoLibrary
		picker.delegate = self
		picker.mediaTypes = [(kUTTypeMovie as NSString) as String, (kUTTypeVideo as NSString) as String]
		
		self.present(picker, animated: true, completion: nil)
	}
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		image = info[UIImagePickerControllerOriginalImage] as! UIImage!
	}
}
