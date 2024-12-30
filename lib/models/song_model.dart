class Song {
  final String title;
  final String number;
  final String markdown;
  bool isFavorite; // New property to indicate if the song is a favourite

  Song({
    required this.title,
    required this.number,
    required this.markdown,
    this.isFavorite = false, // Default value
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'],
      number: json['number']
          .toString(), // Convert number to a string if it's not already
      markdown: json['markdown'] ?? '', // Provide a default value for markdown
      isFavorite:
          json['isFavorite'] ?? false, // Handle isFavorite with a default value
    );
  }

  // Method to convert Song object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'number': number,
      'markdown': markdown,
      'isFavorite': isFavorite, // Serialize isFavorite
    };
  }
}
