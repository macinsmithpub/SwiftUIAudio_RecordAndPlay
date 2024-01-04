//
//  AudioRecorder.swift
//  SwiftUIAudio_RecordAndPlay
//
//  Created by Stephen R Smith on 1/3/24.
//

import SwiftUI

import AVFoundation

public final class AudioRecorder: NSObject, ObservableObject {
    
    @Published public var recordings: [Recording] = []
    @Published var recording = false
    @Published var audioSamples: [RecordingSampleModel] = []
    
    
    static var nextFileIndex  = 0
    
    var audioRecorder = AVAudioRecorder()
    
    let audioFormatID: AudioFormatID
    let sampleRateKey: Float
    let noOfchannels: Int
    let audioQuality: AVAudioQuality
    
    public init(audioFormatID: AudioFormatID, audioQuality: AVAudioQuality, noOfChannels: Int = 2, sampleRateKey: Float = 44100.0) {
        self.audioFormatID = audioFormatID
        self.audioQuality = audioQuality
        self.noOfchannels = noOfChannels
        self.sampleRateKey = sampleRateKey
    }
    
    func startRecording(_ fileName: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("Failed to set up recording session \(error.localizedDescription)")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(fileName).m4a")
        
        UserDefaults.standard.set(audioFilename.absoluteString, forKey: "tempUrl")
        
        let settings: [String:Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVSampleRateKey:44100.0,
            AVNumberOfChannelsKey:2,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            recording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
    }
    
    public func deleteRecording(url: URL, onSuccess: (() -> Void)?) {
        
        do {
            try FileManager.default.removeItem(at: url)
            onSuccess?()
        } catch {
            print("Unable to delete \(url.lastPathComponent)!")
        }
    }
}
