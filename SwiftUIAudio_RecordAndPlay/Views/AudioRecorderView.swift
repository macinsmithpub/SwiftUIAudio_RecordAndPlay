//
//  AudioRecorderView.swift
//  SwiftUIAudio_RecordAndPlay
//
//  Created by Stephen R Smith on 1/3/24.
//

import SwiftUI

struct AudioRecorderView: View {

    @ObservedObject var audioRecorder: AudioRecorder
    
    @State private var isRecording = false
    @State private var isSendingAudio = false
    
    var recordingCancelled: (() -> Void)?
    var recordingComplete: (() -> Void)?
    
    let bgColor: Color? = Color.white
    var fileNameToRecord: String
    
    public init(audioRecorder: AudioRecorder,
                fileNameToRecord: String,
                isRecording: Bool = false,
                isSendingAudio: Bool = false,
                recordingCancelled:  (() -> Void)?,
                recordingComplete:  (() -> Void)?) {
        self.fileNameToRecord = fileNameToRecord
        self.audioRecorder = audioRecorder
        self.isRecording = isRecording
        self.isSendingAudio = isSendingAudio
        self.recordingCancelled = recordingCancelled
        self.recordingComplete = recordingComplete
    }
    var body: some View {
        Button(action: {
            if isRecording {
                stopRecording()
                isRecording = false
            } else {
                startRecording(fileNameToRecord)
                isRecording = true
            }
        }) {
            Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.red)
        }
    }
    
    private func startRecording(_ filename: String) {
        isRecording = true
        audioRecorder.startRecording(filename)
    }
    
    func cancelRecording() {
        
        guard let tempUrl = UserDefaults.standard.string(forKey: "tempUrl") else { return }
        
        if let url = URL(string: tempUrl) {
            
            audioRecorder.deleteRecording(url: url, onSuccess: nil)
        }
        
        isRecording = false
        recordingCancelled?()
    }
    
    func stopRecording() {
        audioRecorder.stopRecording()
        isRecording = false
        isSendingAudio = true
        
        guard let tempUrl = UserDefaults.standard.string(forKey: "tempUrl") else { return }
        
        if let url = URL(string: tempUrl) {
            
            let newRecording = Recording(fileURL: url)
            
            audioRecorder.recordings.append(newRecording)
            AudioRecorder.nextFileIndex += 1
        }
        recordingComplete?()
    }
}
