import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../data/data_loader.dart';
import '../screens/song_detail.dart';

class SongSearchDelegate extends SearchDelegate<Song> {
  late Future<List<Song>> futureSongs;

  SongSearchDelegate() {
    futureSongs = loadSongs();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(
            context,
            Song(
              title: '',
              number: '',
              markdown: '',
            ));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Song>>(
      future: futureSongs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final songs = snapshot.data!
              .where((song) =>
                  song.title.toLowerCase().contains(query.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                tileColor: Colors.white,
                title: Text(song.title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SongDetailScreen(
                        songs: songs,
                        currentIndex: index,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Song>>(
      future: futureSongs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final songs = snapshot.data!
              .where((song) =>
                  song.title.toLowerCase().contains(query.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                title: Text(song.title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SongDetailScreen(
                        songs: songs,
                        currentIndex: index,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
