//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kelly Smith on 5/28/15.
//  Copyright (c) 2015 Kelly Smith. All rights reserved.
//
// Images made by FreePik from www.flaticon.com
// Reverb and Distortion effects were inspired by the following blog:
// http://www.robotlovesyou.com/mixing-between-effects-with-avfoundation/


import AVFoundation
import UIKit

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize AVAudioPlayer & AVAudioEngine objects
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error:nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Play chipmunk (high-pitched) effect
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    // Play Darth Vader effect (low-pitch)
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    // Play a cathedral effect (reverb)
    @IBAction func playCathedral(sender: UIButton) {
        playAudioWithReverb(AVAudioUnitReverbPreset.Cathedral)
    }
    
    // Play an alien-sounding distortion effect
    @IBAction func playAlienAudio(sender: UIButton) {
        playAudioWithDistortion(AVAudioUnitDistortionPreset.MultiEchoTight1)
    }
    
    // Function to play audio with variable pitch effects
    func playAudioWithVariablePitch(pitch: Float) {
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Pitch settings
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    // Function to play audio with variable reverb presets
    func playAudioWithReverb(preset:AVAudioUnitReverbPreset) {
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Reverb settings
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(preset)
        reverbEffect.wetDryMix = 50
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()

    }
    
    // Function to play audio with variable distortion presets
    func playAudioWithDistortion(preset:AVAudioUnitDistortionPreset) {
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Distortion code
        var distortionEffect = AVAudioUnitDistortion()
        distortionEffect.loadFactoryPreset(preset)
        distortionEffect.wetDryMix = 25
        audioEngine.attachNode(distortionEffect)
        
        
        audioEngine.connect(audioPlayerNode, to: distortionEffect, format: nil)
        audioEngine.connect(distortionEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    // Button handler to trigger slow-playback effect (snail)
    @IBAction func slowPlay(sender: UIButton) {
        playAudio(0.5)
    }

    // Function to play audio at variable rates.
    func playAudio(rate : Float) {
        stopAllAudio()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    // Button handler to trigger fast-playback effect (rabbit)
    @IBAction func fastPlay(sender: UIButton) {
        playAudio(2)
    }
    
    // Function to stop all audio players or engines and to reset them.
    func stopAllAudio() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
    }
    
    // Button handler to stop all audio.
    @IBAction func stopPlaying(sender: UIButton) {
        stopAllAudio()
    }


}
