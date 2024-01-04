//
//  AudioPlayerView.swift
//  SwiftUIAudio_RecordAndPlay
//
//  Created by Stephen R Smith on 1/3/24.
//

import SwiftUI

struct AudioPlayerView: View {
    @StateObject var audioPlayer = AudioPlayer()
    
    private var audioUrl: URL
    @State private var isPlaying = false
    
    private var fileName: String?
    
    init(audioUrl: URL, isPlaying: Bool = false, fileName: String? = nil) {
        self.audioUrl = audioUrl
        self.isPlaying = isPlaying
        self.fileName = fileName
    }

    var body: some View {
        
        HStack {
            
            if audioPlayer.isPlaying {
                
                Button(action: stopPlaying) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(uiColor: .systemRed))
                }
                .buttonStyle(.plain)
                
            } else {
                
                Button(action: playAudio) {
                    Image(systemName: "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(uiColor: .systemBlue))
                }
                .buttonStyle(.plain)
                
            }
            Spacer()
            Text(fileName ?? "unknown")
                .font(.system(size: 18))
                .foregroundColor(.orange)
            
        }
        .padding()
        .padding(.vertical)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
                .padding(.vertical)
            
        }
    }
    
    private func playAudio() {
        audioPlayer.startPlayback(audio: audioUrl)
    }
    
    private func stopPlaying() {
        audioPlayer.stopPlayback()
    }
    
}
