//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kelly Smith on 5/23/15.
//  Copyright (c) 2015 Kelly Smith. All rights reserved.
//
// Images made by FreePik from www.flaticon.com

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // Define images for pause/play button toggle
    let imgPlay = UIImage(named:"play.png")
    let imgPause = UIImage(named:"pause.png")
    
    // Set flag for initialization for holding state of pause/play button toggle
    var recordingPaused = false
    
    // Declare variables for audioRecorder and model
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet var recordingStatusLabel: UILabel!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide the Pause/Play/Stop buttons from the UI prior to initialization
        hideControlUI()
        // Enable the record button.
        recordButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func recordAudio(sender: UIButton) {
        // Disable the recording button once pressed
        recordButton.enabled = false
        
        // Change the UI to notify user that recording is in progress
        recordingStatusLabel.text = "Recording in Progress"
        
        // Show the pause/stop UI controls
        showControlUI()
        
        // Define filepath location for saving .WAV audio file (recording).
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Configure audio recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        
        // Record audio
        audioRecorder.record()
    }
    
    // function to hide the stop and pause/play buttons
    func hideControlUI() {
        stopButton.hidden = true
        pauseButton.hidden = true
    }
    
    // function to show the stop and pause/play buttons
    func showControlUI() {
        stopButton.hidden = false
        pauseButton.hidden = false
    }
    
    // Function to handle processing of end of audio recording.
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        // Did it successfully process the audio?
        if (flag) {
            // Yes - audio succesfully processed.
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title:"My Recording")
            
            // Cue segue to next scene
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            // nope - the audio wasn't processed succesfully
            println("Recording was not successful")
            recordButton.enabled = true
            hideControlUI()
        }
        
    }
    
    // Function to pass audio file data to next scene
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    // Function to handle the audio recording pause/play feature.
    @IBAction func pauseButtonClick(sender: UIButton) {
        
        // Logic to change button image found on:
        // http://stackoverflow.com/questions/29520448/how-do-i-toggle-button-images-when-clicked
        
        // Is the recording currently paused?
        if (recordingPaused) {
            // Yes - then unpause it.
            recordingPaused = false
            pauseButton.setImage(imgPause, forState: UIControlState.Normal)
            stopButton.enabled = true
            audioRecorder.record()
            recordingStatusLabel.text = "Recording in Progress"
        } else {
            // No - the recording is not paused, so pause it.
            recordingPaused = true
            pauseButton.setImage(imgPlay, forState: UIControlState.Normal)
            stopButton.enabled = false
            audioRecorder.pause()
            recordingStatusLabel.text = "Paused"
        }
        
        
    }
    
    // Function to handle button clicks on stop recording button
    @IBAction func stopButtonClick(sender: UIButton) {
        recordingStatusLabel.text = "Tap to Record"
        stopButton.hidden = true
        recordButton.enabled = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

}

