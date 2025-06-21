//
//  VoiceViewController.swift
//  CatTranslator
//
//  Created by 김하진 on 6/2/25.
//

import UIKit
import AVFoundation

class AnalysisViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var audioRecorder: AVAudioRecorder?
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 배경 뷰에 그라데이션 적용
        view.applyGradient(colors: [
            UIColor(red: 210/255, green: 245/255, blue: 235/255, alpha: 1),  // 연한 민트 (Mint Cream 느낌)
            UIColor(red: 200/255, green: 230/255, blue: 255/255, alpha: 1)   // 연하늘 + 연보라 느낌
    ])
    }
    
    func requestMicrophonePermission() {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                if granted {
                    print("마이크 사용 허용됨")
                } else {
                    print("마이크 접근 거부됨")
                }
            }
        }

    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if isRecording {
                audioRecorder?.stop()
                isRecording = false
                sender.setTitle("Start Recording", for: .normal)
                print("녹음 종료")
                
                let wavURL = getDocumentsDirectory().appendingPathComponent("recording.wav")
                
                // 재생 테스트
                do {
                    let player = try AVAudioPlayer(contentsOf: wavURL)
                    player.prepareToPlay()
                    player.play()
                    print("WAV 파일 재생 성공")
                } catch {
                    print("WAV 재생 실패: \(error.localizedDescription)")
                }

                // WAV 전송
                self.uploadWavFile(fileURL: wavURL)
                print("파일 전송 시작")

                let asset = AVURLAsset(url: wavURL)
                let duration = CMTimeGetSeconds(asset.duration)
                print("WAV 길이: \(duration)초")

            } else {
                startRecording()
                isRecording = true
                sender.setTitle("Stop Recording", for: .normal)
                print("녹음 시작")
            }
    }
    
    func startRecording() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)

            let url = getDocumentsDirectory().appendingPathComponent("recording.wav")  // 바로 WAV로 저장

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),            // WAV 포맷
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsFloatKey: false
            ]

            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.record()

            print("녹음 시작 (WAV 형식) -> \(url)")
        } catch {
            print("녹음 실패: \(error)")
        }
    }


    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)[0]
    }
    
    func convertM4AToWAV_usingAVAudioFile(inputURL: URL, outputFileName: String, completion: @escaping (URL?) -> Void) {
        let outputURL = getDocumentsDirectory().appendingPathComponent(outputFileName)

        do {
            let audioFile = try AVAudioFile(forReading: inputURL)
            guard let format = AVAudioFormat(commonFormat: .pcmFormatInt16,
                sampleRate: audioFile.fileFormat.sampleRate,
                channels: audioFile.fileFormat.channelCount,
                interleaved: true) else {
                print("AVAudioFormat 생성 실패")
                completion(nil)
                return
            }

            let outputFile = try AVAudioFile(forWriting: outputURL, settings: format.settings)

            let bufferCapacity = AVAudioFrameCount(audioFile.length)
            guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: bufferCapacity) else {
                print("AVAudioPCMBuffer 생성 실패")
                completion(nil)
                return
            }

            try audioFile.read(into: buffer)
            try outputFile.write(from: buffer)

            print("변환 성공: \(outputURL)")
            completion(outputURL)
        } catch {
            print("변환 중 오류 발생: \(error)")
            completion(nil)
        }
    }

    func uploadWavFile(fileURL: URL) {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "http://192.168.219.102:8080/api/audio")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // 인증된 사용자만 기능 사용 가능
        if let token = TokenManager.getToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("토큰이 없음")
            return
        }
        
        var body = Data()

        // WAV 파일 추가
        if let fileData = try? Data(contentsOf: fileURL) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"converted.wav\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
            print("전송할 파일 경로: \(fileURL)")
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
            print("전송할 파일 크기: \(fileData.count) bytes")
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        // 전송
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("전송 실패: \(error)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image // imageView는 반드시 @IBOutlet으로 연결되어 있어야 함
                }
            } else {
                print("이미지로 변환 실패")
            }
        }.resume()
        
    }


}
