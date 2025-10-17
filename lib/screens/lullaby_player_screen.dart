import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:provider/provider.dart';
import '../audio_manager.dart';
import '../utils/theme_manager.dart'; // 👈 Added ThemeManager import

enum RepeatMode { off, all, one }

class LullabyPlayerScreen extends StatefulWidget {
  const LullabyPlayerScreen({Key? key}) : super(key: key);

  @override
  State<LullabyPlayerScreen> createState() => _LullabyPlayerScreenState();
}

class _LullabyPlayerScreenState extends State<LullabyPlayerScreen>
    with WidgetsBindingObserver {
  final AudioPlayer _player = AudioManager().player;
  String? selectedPlaylist;
  String? selectedSong;
  bool isPlaying = false;
  RepeatMode _repeatMode = RepeatMode.off;
  double _currentVolume = 1.0;

  final Map<String, List<Map<String, String>>> playlists = {
    "Lullabies": [
      {"title": "Twinkle Twinkle", "asset": "assets/audio/lullaby1.mp3"},
      {"title": "Brahms Lullaby", "asset": "assets/audio/lullaby2.mp3"},
      {"title": "Lullaby Kannada", "asset": "assets/audio/lullaby3.mp3"},
    ],
    "Nature Sounds": [
      {"title": "Rain Sound", "asset": "assets/audio/rain.mp3"},
      {"title": "Forest Sound", "asset": "assets/audio/forest.mp3"},
    ],
    "Favorites": [
      {"title": "Soft Piano", "asset": "assets/audio/piano1.mp3"},
    ],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupAudioSession();

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_repeatMode == RepeatMode.one) {
          _player.seek(Duration.zero);
          _player.play();
        } else {
          playNextSong(auto: true);
        }
      }
    });
  }

  Future<void> _setupAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  }

  void selectPlaylist(String playlist) {
    setState(() {
      selectedPlaylist = playlist;
      selectedSong = null;
    });
  }

  Future<void> playSong(Map<String, String> song) async {
    try {
      await _player.setAsset(song['asset']!);
      await _player.play();
      setState(() {
        selectedSong = song['title'];
        isPlaying = true;
      });
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  void togglePlayback() async {
    if (isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void playNextSong({bool auto = false}) {
    if (selectedPlaylist != null && selectedSong != null) {
      final songs = playlists[selectedPlaylist]!;
      int currentIndex =
          songs.indexWhere((s) => s['title'] == selectedSong);
      int nextIndex = currentIndex + 1;

      if (nextIndex >= songs.length) {
        if (_repeatMode == RepeatMode.all || auto) {
          nextIndex = 0;
        } else {
          _player.stop();
          setState(() {
            isPlaying = false;
          });
          return;
        }
      }
      playSong(songs[nextIndex]);
    }
  }

  void playPreviousSong() {
    if (selectedPlaylist != null && selectedSong != null) {
      final songs = playlists[selectedPlaylist]!;
      int currentIndex =
          songs.indexWhere((s) => s['title'] == selectedSong);
      int prevIndex = currentIndex - 1;

      if (prevIndex < 0) {
        prevIndex = songs.length - 1;
      }
      playSong(songs[prevIndex]);
    }
  }

  void addToFavorites() {
    if (selectedSong != null) {
      final song = playlists[selectedPlaylist]!.firstWhere(
          (s) => s['title'] == selectedSong,
          orElse: () => {});
      final isFav = playlists["Favorites"]!
          .any((s) => s['title'] == selectedSong);
      if (!isFav) {
        playlists["Favorites"]!.add(song);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$selectedSong added to Favorites!')),
        );
      } else {
        playlists["Favorites"]!
            .removeWhere((s) => s['title'] == selectedSong);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$selectedSong removed from Favorites!')),
        );
      }
      setState(() {});
    }
  }

  bool isFavorite(String songTitle) {
    return playlists["Favorites"]!
        .any((s) => s['title'] == songTitle);
  }

  void toggleRepeatMode() {
    setState(() {
      if (_repeatMode == RepeatMode.off) {
        _repeatMode = RepeatMode.all;
      } else if (_repeatMode == RepeatMode.all) {
        _repeatMode = RepeatMode.one;
      } else {
        _repeatMode = RepeatMode.off;
      }
    });
  }

  IconData get repeatModeIcon {
    switch (_repeatMode) {
      case RepeatMode.all:
        return Icons.repeat;
      case RepeatMode.one:
        return Icons.repeat_one;
      case RepeatMode.off:
        return Icons.repeat;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeManager>(context); // 👈 Get ThemeManager
    final isDark = themeProvider.isDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎶 Lullaby Player'),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: isDark ? Colors.black26 : Colors.deepPurple[50],
              child: ListView(
                children: playlists.keys.map((playlist) {
                  return ListTile(
                    title: Text(
                      playlist,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    leading: Icon(
                      Icons.library_music,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    selected: selectedPlaylist == playlist,
                    onTap: () => selectPlaylist(playlist),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: isDark ? Colors.black38 : Colors.deepPurple[100],
              child: selectedPlaylist == null
                  ? Center(
                      child: Text(
                        "Select a Playlist",
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87),
                      ),
                    )
                  : ListView(
                      children: playlists[selectedPlaylist]!.map((song) {
                        return ListTile(
                          title: Text(
                            song['title']!,
                            style: TextStyle(
                                color:
                                    isDark ? Colors.white : Colors.black87),
                          ),
                          leading: Icon(Icons.music_note,
                              color: isDark ? Colors.white : Colors.black87),
                          selected: selectedSong == song['title'],
                          onTap: () => playSong(song),
                        );
                      }).toList(),
                    ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: isDark ? Colors.black54 : Colors.deepPurple[200],
              child: selectedSong == null
                  ? Center(
                      child: Text(
                        "Select a Song",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // CD + Song name + Volume
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.album,
                                    size: 100,
                                    color:
                                        isDark ? Colors.white : Colors.black),
                                const SizedBox(height: 10),
                                Text(
                                  selectedSong!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Column(
                              children: [
                                RotatedBox(
                                  quarterTurns: -1,
                                  child: Slider(
                                    min: 0,
                                    max: 1,
                                    value: _currentVolume,
                                    onChanged: (value) {
                                      setState(() {
                                        _currentVolume = value;
                                      });
                                      _player.setVolume(value);
                                    },
                                    activeColor: Colors.purpleAccent,
                                    inactiveColor: Colors.purple[100],
                                  ),
                                ),
                                Icon(Icons.volume_up,
                                    color: isDark ? Colors.white : Colors.black),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Buttons (no change)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: playPreviousSong,
                              icon: Icon(Icons.skip_previous,
                                  size: 36,
                                  color:
                                      isDark ? Colors.white : Colors.black),
                            ),
                            IconButton(
                              onPressed: togglePlayback,
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_circle
                                    : Icons.play_circle,
                                size: 50,
                                color:
                                    isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: playNextSong,
                              icon: Icon(Icons.skip_next,
                                  size: 36,
                                  color:
                                      isDark ? Colors.white : Colors.black),
                            ),
                            IconButton(
                              onPressed: addToFavorites,
                              icon: Icon(
                                isFavorite(selectedSong!)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 30,
                                color: isFavorite(selectedSong!)
                                    ? Colors.red
                                    : (isDark
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                            IconButton(
                              onPressed: toggleRepeatMode,
                              icon: Icon(
                                repeatModeIcon,
                                size: 30,
                                color: _repeatMode == RepeatMode.off
                                    ? Colors.white54
                                    : (isDark
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Updated Seekbar
                        StreamBuilder<Duration>(
                          stream: _player.positionStream,
                          builder: (context, snapshot) {
                            final position =
                                snapshot.data ?? Duration.zero;
                            final total =
                                _player.duration ?? Duration.zero;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Slider(
                                    min: 0,
                                    max: total.inMilliseconds.toDouble(),
                                    value: position.inMilliseconds
                                        .clamp(0, total.inMilliseconds)
                                        .toDouble(),
                                    onChanged: (value) {
                                      _player.seek(Duration(
                                          milliseconds: value.toInt()));
                                    },
                                    activeColor: Colors.purpleAccent,
                                    inactiveColor: Colors.purple[100],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${_formatDuration(position)} / ${_formatDuration(total)}',
                                  style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
