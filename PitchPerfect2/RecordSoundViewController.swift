//
//  ViewController.swift
//  PitchPerfect2
//
//  Created by bao on 5/31/15.
//  Copyright (c) 2015 baoca. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
   
    
    @IBOutlet weak var tabToRecord: UILabel! //Outlet for "Tab to record" label
    @IBOutlet weak var recordingProgress: UILabel! //Outlet for "recording"label
    @IBOutlet weak var stopButton: UIButton! //Outlet for stop button
     @IBOutlet weak var recordingButtonProgress: UIButton! //Outlet for record button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    
   
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBAction func recordButton(sender: AnyObject) {
        
        //Hide or appear buttons or labels:
        recordingProgress.hidden = false //let appeared the "recording"label
        stopButton.hidden = false //let appeared the stop button
        tabToRecord.hidden = true //hide the "Tab to Record" label
        recordingButtonProgress.enabled = false //disable the record button
      
        //create directories for the file:
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        //set the time and format the time, then use the string for the name.wav:
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        
        //convert to NSURL:
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //create session of recording and record:
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //use this function to know if the recording is finished
        
        // save the file:
        if (flag) {
        recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        // creat segue way to move to sound effect screen:
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
            
        } else {//if not succeeded do the following:
            println("Recording was not successful")
            recordingButtonProgress.enabled = true //enable the record button
            stopButton.hidden = true //hide the stop button
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //prepare for Segue:
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        
        //hide or appear buttons or labels:
        recordingProgress.hidden = true // hide the "recording" label
        recordingButtonProgress.enabled = true //enable the record button
        tabToRecord.hidden = false //let appeared the "Tab to record" label
        
        //Stop recording:
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true //stop button is hidden after loading view
    }
}