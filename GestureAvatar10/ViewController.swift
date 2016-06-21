//
//  ViewController.swift
//  GestureAvatar10
//
//  Created by Yujung Lee on 2016. 6. 20..
//  Copyright © 2016년 YujungLee. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController, UITextFieldDelegate {

    let avPlayerViewController = AVPlayerViewController();
    var avPlayer: AVPlayer?
    var avplayerlayer: AVPlayerLayer = AVPlayerLayer()
    var inputText: String = "Demo1_1"
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var videoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playMovie()
        
        self.inputTextField.delegate = self
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory.....is .....*Dead*")
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func playButtonTapped(sender: AnyObject) {
        /*
        self.presentViewController(self.avPlayerViewController, animated: true) { 
            ()->Void in self.avPlayerViewController.player?.play()
        }//재생이 끝나면 반복재생*/
        self.avPlayer?.play()
    }

    
    @IBAction func pauseButtonTapped(sender: AnyObject) {
        self.avPlayer?.pause()
    }
    
    /* Textfield and Keyboard */
    //keyboard resign function
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        guard let text: String = textField.text else  {
            return
        }
        inputText = text
        playMovie()
        self.avPlayer?.play()
    }

    /* movie play function */
    func playMovie() {
        
         let serverString: String = "http://cspc.sogang.ac.kr/~yjlee127/capstone/"
         let movieString: String = serverString + inputText + ".mp4"
         let movieUrl: NSURL? = NSURL(string: movieString)
        print(movieUrl)

        
        //optional binding. movieUrl이 실제로 있는 url인지 확인하기 위함
        if let url = movieUrl {
            self.avPlayer = AVPlayer(URL: url)
            avplayerlayer = AVPlayerLayer(player: self.avPlayer)
            avplayerlayer.frame = videoView.bounds
            
            avplayerlayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.85, height: self.view.frame.size.width*0.9)
            
            avplayerlayer.videoGravity = AVLayerVideoGravityResizeAspect
            avplayerlayer.needsDisplayOnBoundsChange = true
            
            videoView.layer.addSublayer(avplayerlayer)
            videoView.layer.needsDisplayOnBoundsChange = true
            
            self.avPlayerViewController.player = self.avplayerlayer.player
            
        }
    }
    
    
    @IBAction func startButtonTapped(sender: AnyObject) {
        inputText = "Demo1_1"
        playMovie()
        self.avPlayer?.play()
    }
    
    @IBAction func endButtonTapped(sender: AnyObject) {
        inputText = "Demo2_4"
        playMovie()
        self.avPlayer?.play()
    }
}

