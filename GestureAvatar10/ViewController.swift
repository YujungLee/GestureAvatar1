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
    var endFlag: Bool = false//비디오가 끝났는지 표시하는 플래그, true이면 끝난것
    var questionFlag: Bool = false//방금 재생한 제스쳐가 변경질문 혹은 삭제질문일 경우 true, 아닐 경우 false
    let questionDict: [String:String] = ["점심 1시로":"Demo1_2", "치매 일정 취소":"Demo2_2"]
    let answerDict: [String:String] = ["점심 1시로":"Demo1_3", "치매 일정 취소":"Demo2_3"]
    var prevQuestion: String = String()
    
    
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
        if endFlag == true{
            restartPlayerFromBeginning()
            endFlag = false
        }
        else {
            self.avPlayer?.play()
     
        }
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
        
        //<<debug
        print(inputText)
        //debug>>
        
        playMovie()
        self.avPlayer?.play()
    }

    /* movie play function */
    func playMovie() {
        
        let serverString: String = "http://cspc.sogang.ac.kr/~yjlee127/capstone/"
        var videoName : String = "Demo1_1"
        videoName = findVideo()
        
        let movieString: String = serverString + videoName + ".mp4"
        let movieUrl: NSURL? = NSURL(string: movieString)
        
        //debug
        print(movieUrl)

        
        //optional binding. movieUrl이 실제로 있는 url인지 확인하기 위함
        if let url = movieUrl {
            self.avPlayer = AVPlayer(URL: url)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification,
                                                             object: self.avPlayer?.currentItem)
            
            
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
        inputText = "start"
        playMovie()
        self.avPlayer?.play()
    }
    
    @IBAction func endButtonTapped(sender: AnyObject) {
        inputText = "end"
        playMovie()
        self.avPlayer?.play()
    }
    
    
    //동영상 끝나면 호출되는 함수
    func playerDidFinishPlaying(note: NSNotification){
        print("video finished")
        endFlag = true
    }
    
    //동영상 재시작 함수
    func restartPlayerFromBeginning() {
        let seconds : Int64 = 0
        let preferredTimeScale : Int32 = 1
        let seekTime : CMTime = CMTimeMake(seconds, preferredTimeScale)
        
        self.avPlayer?.seekToTime(seekTime)
        self.avPlayer?.play()
    }
    
    
    func findVideo() -> String {
        if inputText == "start"{
            return "Demo1_1"
        }
        else if inputText == "end"
        {
            return "Demo2_4"
        }
        
        if questionFlag == false{
            let videoName = questionDict[inputText]
            if videoName != nil{
                questionFlag = true
                prevQuestion = inputText
                return videoName!
            }
            else{
                return "pardon"
            }
        }
        else{
            questionFlag = false
            if inputText == "응"{
                let videoName = answerDict[prevQuestion]
                if videoName != nil{
                    return videoName!
                }
                else{
                    return "pardon"
                }
            }
            else if inputText == "아니"{
                return "YesIKnow"
            }
            else {
                return "pardon"
            }
        }
    }
    
}

