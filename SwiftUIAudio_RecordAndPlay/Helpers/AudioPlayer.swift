//
//  AudioPlayer.swift
//  SwiftUIAudio_RecordAndPlay
//
//  Created by Stephen R Smith on 1/3/24.
//

import SwiftUI
import AVFoundation

public final class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published public var audioSamples: [SampleModel] = []
    @Published public var isPlaying = false
    
    var audioPlayer = AVAudioPlayer()
    static let shared = AudioPlayer()

    func startPlayback(audio: URL) {
        do {
            
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.volume = 1.0
            audioPlayer.delegate = self
            audioPlayer.play()
            
            withAnimation {
                isPlaying = true
            }
            
        } catch let error {
            print("Playback failed.\(error.localizedDescription)")
        }
    }
    
    public func stopPlayback() {
        audioPlayer.stop()
        
        withAnimation {
            isPlaying = false
        }
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            stopPlayback()
        }
    }

}
