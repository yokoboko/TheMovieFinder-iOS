//
//  YoutubePlayerVC.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 11.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit
import WebKit

class YoutubePlayerVC: UIViewController, WKScriptMessageHandler {

    private var videoID: String
    private var player: WKWebView!

    private var isDismissing = false

    init(videoID: String) {
        self.videoID = videoID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let userContentController = WKUserContentController()
        userContentController.add(self, name: YouTubePlayerEvent.onReady.rawValue)

        let configuration = WKWebViewConfiguration()
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        configuration.userContentController = userContentController

        player = WKWebView(frame: .zero, configuration: configuration)
        player.translatesAutoresizingMaskIntoConstraints = false
        player.scrollView.bounces = false
        player.scrollView.isScrollEnabled = false
        player.isUserInteractionEnabled = true
        player.backgroundColor = .black
        player.scrollView.backgroundColor = .black
        player.isOpaque = false
        player.layer.cornerRadius = 10
        player.layer.masksToBounds = true
        view.addSubview(player)

        let doneBtn = UIButton()
        doneBtn.setTitle("done".localized, for: .normal)
        doneBtn.setTitleColor(UIColor.movieFinder.tertiery, for: .normal)
        doneBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        doneBtn.layer.cornerRadius = 25
        doneBtn.layer.borderWidth = 1
        doneBtn.layer.borderColor = UIColor.movieFinder.tertiery.cgColor
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        doneBtn.isUserInteractionEnabled = false
        view.addSubview(doneBtn)

        NSLayoutConstraint.activate([
            player.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 30),
            player.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: -30),
            player.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 50),
            player.heightAnchor.constraint(equalTo: player.widthAnchor, multiplier: 3 / 4),

            doneBtn.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 30),
            doneBtn.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: -30),
            doneBtn.heightAnchor.constraint(equalToConstant: 50),
            doneBtn.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -32)
            ])

        player.loadHTMLString(playerHtml, baseURL: URL(string: "https://www.youtube.com"))


        NotificationCenter.default.addObserver(self, selector: #selector(onDidLeaveFullscreen(_:)), name: UIWindow.didBecomeHiddenNotification, object: view.window)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func tapGesture() {
            dismissYoutubeVideo()
    }

    @objc func onDidLeaveFullscreen(_ notification: Notification) {
            dismissYoutubeVideo()
    }

    private func dismissYoutubeVideo() {
        if !isDismissing {
            isDismissing = true
            player.stopLoading()
            dismiss(animated: true)
        }
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        guard let event = YouTubePlayerEvent(rawValue: message.name) else { return }
        switch event {
        case .onReady:
            if !isDismissing {
                playVideo()
            }
        default: break
        }
    }

    private func playVideo() {
        evaluatePlayerCommand("playVideo()")
    }

    // Evaluate javascript command and convert to simple error(nil) if an error is occurred.
    private func evaluatePlayerCommand(_ commandName: String, callbackHandler: ((Any?) -> ())? = nil) {
        let command = "player.\(commandName);"
        player.evaluateJavaScript(command) { (result, error) in
            if error != nil {
                callbackHandler?(nil)
                return
            }
            callbackHandler?(result)
        }
    }

    public enum YouTubePlayerEvent: String {
        case onYoutubeIframeAPIReady        = "onYouTubeIframeAPIReady"
        case onYouTubeIframeAPIFailedToLoad = "onYouTubeIframeAPIFailedToLoad"
        case onReady                        = "onReady"
        case onStateChange                  = "onStateChange"
        case onQualityChange                = "onPlaybackQualityChange"
        case onPlaybackRateChange           = "onPlaybackRateChange"
        case onApiChange                    = "onApiChange"
        case onError                        = "onError"
        case onUpdateCurrentTime            = "onUpdateCurrentTime"
    }

    private var playerHtml: String {
        return
            """
        <!DOCTYPE html>
        <html>
        <head>
        <style>
        html, body { margin: 0; padding: 0; width: 100%; height: 100%; background-color: #000000; }
        </style>
        </head>
        <body>
        <div id="player"></div>
        <div id="explain"></div>
        <script src="https://www.youtube.com/iframe_api" onerror="webkit.messageHandlers.onYouTubeIframeAPIFailedToLoad.postMessage('')"></script>
        <script>
        var player;
        var time;
        YT.ready(function() {
        player = new YT.Player('player', {
                                            videoId: '\(videoID)',
                                            playerVars: {
                                                'autoplay': 0,
                                                'controls': 0,
                                                'rel' : 0,
                                                'fs' : 0,
                                            },
                                            height: '100%',
                                            width: '100%',
                                            events: {
                                                'onReady': onReady,
                                                'onStateChange': onStateChange,
                                                'onPlaybackQualityChange': onPlaybackQualityChange,
                                                'onPlaybackRateChange': onPlaybackRateChange,
                                                'onPlayerError': onPlayerError,
                                                'onApiChange': onApiChange
                                            }
                                        });
            webkit.messageHandlers.onYouTubeIframeAPIReady.postMessage('');
            function updateTime() {
                var state = player.getPlayerState();
                if (state == YT.PlayerState.PLAYING) {
                    time = player.getCurrentTime();
                    webkit.messageHandlers.onUpdateCurrentTime.postMessage(time);
                }
            }
            window.setInterval(updateTime, 500);
        });
        function onReady(event) {
            webkit.messageHandlers.onReady.postMessage('');
        }
        function onStateChange(event) {
            webkit.messageHandlers.onStateChange.postMessage(event.data);
        }
        function onPlaybackQualityChange(event) {
            webkit.messageHandlers.onPlaybackQualityChange.postMessage(event.data);
        }
        function onPlaybackRateChange(event) {
            webkit.messageHandlers.onPlaybackRateChange.postMessage(event.data);
        }
        function onPlayerError(event) {
            webkit.messageHandlers.onError.postMessage(event.data);
        }
        function onApiChange(event) {
            webkit.messageHandlers.onApiChange.postMessage(event.data);
        }
        </script>
        </body>
        </html>
        """
    }
}
