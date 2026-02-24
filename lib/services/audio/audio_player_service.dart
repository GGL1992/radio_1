import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../../data/models/radio_station.dart';

enum PlaybackStatus {
  idle,
  loading,
  playing,
  paused,
  buffering,
  error,
}

class AudioState {
  final PlaybackStatus status;
  final RadioStation? currentStation;
  final Duration position;
  final Duration duration;
  final double volume;
  final double speed;
  final String? errorMessage;
  final bool isLive;

  const AudioState({
    this.status = PlaybackStatus.idle,
    this.currentStation,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.volume = 0.7,
    this.speed = 1.0,
    this.errorMessage,
    this.isLive = true,
  });

  AudioState copyWith({
    PlaybackStatus? status,
    RadioStation? currentStation,
    Duration? position,
    Duration? duration,
    double? volume,
    double? speed,
    String? errorMessage,
    bool? isLive,
  }) {
    return AudioState(
      status: status ?? this.status,
      currentStation: currentStation ?? this.currentStation,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
      speed: speed ?? this.speed,
      errorMessage: errorMessage,
      isLive: isLive ?? this.isLive,
    );
  }
}

class AudioPlayerService {
  final AudioPlayer _player;
  final StreamController<AudioState> _stateController = 
      StreamController<AudioState>.broadcast();
  
  AudioState _state = const AudioState();
  AudioState get state => _state;
  Stream<AudioState> get stateStream => _stateController.stream;

  AudioPlayerService() : _player = AudioPlayer() {
    _initAudioSession();
    _listenToPlayerState();
  }

  void _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: false,
    ));
  }

  void _listenToPlayerState() {
    _player.playerStateStream.listen((playerState) {
      final processingState = playerState.processingState;
      final playing = playerState.playing;

      PlaybackStatus status;
      if (processingState == ProcessingState.idle) {
        status = PlaybackStatus.idle;
      } else if (processingState == ProcessingState.loading ||
                 processingState == ProcessingState.buffering) {
        status = PlaybackStatus.buffering;
      } else if (playing) {
        status = PlaybackStatus.playing;
      } else {
        status = PlaybackStatus.paused;
      }

      _updateState(_state.copyWith(status: status));
    });

    _player.positionStream.listen((position) {
      _updateState(_state.copyWith(position: position));
    });

    _player.durationStream.listen((duration) {
      if (duration != null) {
        _updateState(_state.copyWith(duration: duration));
      }
    });

    _player.volumeStream.listen((volume) {
      _updateState(_state.copyWith(volume: volume));
    });
  }

  void _updateState(AudioState newState) {
    _state = newState;
    _stateController.add(_state);
  }

  Future<void> playStation(RadioStation station) async {
    try {
      _updateState(_state.copyWith(
        status: PlaybackStatus.loading,
        currentStation: station,
        isLive: true,
      ));

      await _player.setUrl(station.streamUrl);
      await _player.play();

      _updateState(_state.copyWith(
        status: PlaybackStatus.playing,
        currentStation: station,
        errorMessage: null,
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        status: PlaybackStatus.error,
        errorMessage: '播放失败: ${e.toString()}',
      ));
    }
  }

  Future<void> playLocalFile(String filePath) async {
    try {
      _updateState(_state.copyWith(
        status: PlaybackStatus.loading,
        isLive: false,
      ));

      await _player.setFilePath(filePath);
      await _player.play();

      _updateState(_state.copyWith(
        status: PlaybackStatus.playing,
        errorMessage: null,
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        status: PlaybackStatus.error,
        errorMessage: '播放失败: ${e.toString()}',
      ));
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
    _updateState(const AudioState());
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed.clamp(0.25, 4.0));
    _updateState(_state.copyWith(speed: speed));
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  void dispose() {
    _player.dispose();
    _stateController.close();
  }
}

// Riverpod Provider
final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  return AudioPlayerService();
});
