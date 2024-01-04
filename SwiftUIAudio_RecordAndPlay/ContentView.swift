//
//  ContentView.swift
//  SwiftUIAudio_RecordAndPlay
//
//  Created by Stephen R Smith on 1/3/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var audioFiles: [URL?] = [
        Bundle.main.url(forResource: "ph1", withExtension: nil),
        Bundle.main.url(forResource: "ph2", withExtension: nil),
        Bundle.main.url(forResource: "ph3", withExtension: nil),
    ]
    @State private var isRecording = false
    @State private var isPlaying = false
    @StateObject var recorder = AudioRecorder( audioFormatID: kAudioFormatAppleLossless, audioQuality: .max)
    
    
    var body: some View {
        VStack {
            Text("My Recordings")
                .foregroundColor(.black)
                .font(.system(size: 15)).bold()
            
            List {
                
                ForEach(recorder.recordings, id: \.uid) { recording in
                    AudioPlayerView(audioUrl: recording.fileURL, fileName: recording.fileURL.lastPathComponent)
                }
                .onDelete { indexSet in
                    delete(at: indexSet)
                }
            }
            .listStyle(.inset)
            Spacer()
        }
        AudioRecorderView(audioRecorder: recorder, fileNameToRecord: "sample\(AudioRecorder.nextFileIndex)") {
            
        }
    recordingComplete: {
        
    }
        HStack (spacing: 10) {
            Button("Boing") {
                playSound("boing.mp3")
            }
            Button("Ding") {
                playSound("Ding.mp3")
            }
            Button("Shot") {
                playSound("Shot.m4a")
            }
        }
        .padding()
    }
    
    func playSound(_ fileName: String) {
        guard let soundFileURL = Bundle.main.url(
            forResource: fileName,
            withExtension: nil)
        else {
            return
        }
        playSound(soundFileURL)
    }
    
    func playSound(_ url: URL?) {
        guard let url = url else {
            print("url not found")
            return
        }
        let audioPlayer = AudioPlayer.shared
        audioPlayer.startPlayback(audio: url)
        
    }
    
    func delete(at offsets: IndexSet) {

        var recordingIndex: Int = 0

        for index in offsets {
            recordingIndex = index
        }

        let recording = recorder.recordings[recordingIndex]
        recorder.deleteRecording(url: recording.fileURL, onSuccess: {
            recorder.recordings.remove(at: recordingIndex)
        })
    }
}

#Preview {
    ContentView()
}
