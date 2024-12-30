import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/song_model.dart';
import './song_detail.dart'; // Import SongDetailScreen

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Song>> _loadFavourites() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> results = await db.query('favourites');
    return results.map((item) {
      return Song(
        title: item['title'],
        number: item['number'],
        markdown: item['markdown'],
        isFavorite: item['isFavorite'] == 1,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Favourites'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF145F3A),
      ),

      // Use FutureBuilder to load the list of favorites
      body: FutureBuilder<List<Song>>(
        future: _loadFavourites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a circular spinner while waiting
            return const Center();
          } else if (snapshot.hasError) {
            // Show an error message if something goes wrong
            return Center(
              child: Text('An error occurred: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            // Show a message if there are no favorites
            return const Center(
              child: Text('Your favourite items will appear here.'),
            );
          } else if (snapshot.hasData) {
            // Show the list of favorites
            final favourites = snapshot.data!;
            return ListView.builder(
              itemCount: favourites.length,
              itemBuilder: (context, index) {
                final song = favourites[index];
                return ListTile(
                  tileColor: Colors.white,
                  title: Text(song.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _dbHelper.removeFromFavorites(song.title);
                      setState(() {});
                    },
                  ),
                  onTap: () {
                    // Navigate to SongDetailScreen and open the tapped song
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongDetailScreen(
                          songs: favourites, // Pass the favorites list
                          currentIndex: index, // Pass the tapped song index
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text('No data found.'),
            );
          }
        },
      ),
    );
  }
}
