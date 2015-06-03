//
//  PlaySoundsViewController.swift
//  PitchPerfect2
//
//  Created by bao on 5/31/15.
//  Copyright (c) 2015 baoca. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl , error: nil )
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    
    
    @IBAction func playDarthAudio(sender: AnyObject) {
        //call the function playAudioWithVariablePitch
        playAudioWithVariablePitch(-1000)
    }
  
    
    @IBAction func playChipAudio(sender: AnyObject) {
    //call the function playAudioWithVariablePitch
        playAudioWithVariablePitch(1000)
    }
    
    
    func playAudioWithVariablePitch (pitch: Float) {
        //Stop audioPlayer and audioEngine in order not to overlap the sound being playing:
            audioPlayer.stop()
            audioEngine.stop()
            audioEngine.reset()
        
        //create Node
             var audioPlayerNode = AVAudioPlayerNode()
            audioEngine.attachNode(audioPlayerNode)
        
        //change pitch
            var changePitchEffect = AVAudioUnitTimePitch()
            changePitchEffect.pitch = pitch
            audioEngine.attachNode(changePitchEffect)
        
        //Connect Node with pitch effect
            audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
            audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
            audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
            audioEngine.startAndReturnError(nil)
            
        //Play audio with effect
        audioPlayerNode.play()
    }
    
    @IBAction func playFastAudio(sender: AnyObject) {
        //Stop audioPlayer and audioEngine in order not to overlap the sound being playing:
        audioPlayer.stop()
        audioEngine.stop()
        
        //set rate and time, then play audio
        audioPlayer.rate = 2
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        //Stop all the sound if we tab the stop button
        audioPlayer.stop()
        audioEngine.stop()
    }
    
    @IBAction func playSlowAudio(sender: AnyObject) {
        //Stop audioPlayer and audioEngine in order not to overlap the sound being playing:
        audioPlayer.stop()
        audioEngine.stop()
        
        //set rate and time, then play audio
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    


}
