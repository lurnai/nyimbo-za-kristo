import 'package:flutter/material.dart';
import '../models/song_model.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../database/database_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SongDetailScreen extends StatefulWidget {
  final List<Song> songs;
  final int currentIndex;

  const SongDetailScreen({
    Key? key,
    required this.songs,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _SongDetailScreenState createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  late PageController _pageController;
  late int _currentIndex;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _checkFavoriteStatus();
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/9214589741',
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  // Check the favorite status of the current song
  void _checkFavoriteStatus() async {
    bool isFav = await _dbHelper.isFavorite(widget.songs[_currentIndex].title);
    setState(() {
      widget.songs[_currentIndex].isFavorite = isFav;
    });
  }

  // Toggle favorite status and update the database
  void _toggleFavorite() async {
    final currentSong = widget.songs[_currentIndex];
    if (currentSong.isFavorite) {
      await _dbHelper.removeFromFavorites(currentSong.title);
    } else {
      await _dbHelper.addToFavorites(currentSong);
    }
    setState(() {
      currentSong.isFavorite = !currentSong.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.songs[_currentIndex].title),
        titleTextStyle: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              widget.songs[_currentIndex].isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.songs.length,
        itemBuilder: (context, index) {
          final song = widget.songs[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MarkdownBody(
                    data: song.markdown,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                      p: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 18.0),
                      h3: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
            _checkFavoriteStatus();
          });
        },
      ),
      bottomSheet: _isAdLoaded
          ? SizedBox(
              height: 50.0,
              child: AdWidget(ad: _bannerAd),
            )
          : null,
    );
  }
}
