import '../../domain/entities/home_entity.dart';

class MovieModel extends MovieEntity {
  // Extra dummy fields for UI/demo only
  final double rating;
  final int releaseYear;
  final String genre;

  const MovieModel({
    required int albumId,
    required int id,
    required String title,
    required String url,
    required String thumbnailUrl,
    this.rating = 0.0,
    this.releaseYear = 2000,
    this.genre = 'Unknown',
  }) : super(
         albumId: albumId,
         id: id,
         title: title,
         url: url,
         thumbnailUrl: thumbnailUrl,
       );

  // Factory method to create a model from JSON, populating random dummy fields if missing
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final model = MovieModel(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      releaseYear: json['releaseYear'] as int? ?? 2000,
      genre: json['genre'] as String? ?? 'Unknown',
    );
    // If any dummy field is missing or default, populate with random dummy data
    if (model.rating == 0.0 ||
        model.releaseYear == 2000 ||
        model.genre == 'Unknown') {
      return model._populateRandomDummyFieldsForModel();
    }
    return model;
  }

  // Helper to populate random dummy fields for a single MovieModel
  MovieModel _populateRandomDummyFieldsForModel() {
    final genres = [
      'Action',
      'Drama',
      'Comedy',
      'Sci-Fi',
      'Adventure',
      'Crime',
      'Fantasy',
      'Thriller',
      'Animation',
      'Romance',
    ];
    final now = DateTime.now().year;
    final i = id; // Use id for deterministic randomness
    return copyWith(
      rating: 6.0 + (i % 5) + (i * 0.13) % 1.5, // 6.0-10.0
      releaseYear: now - (i * 3) % 30, // last 30 years
      genre: genres[i % genres.length],
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'id': id,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'rating': rating,
      'releaseYear': releaseYear,
      'genre': genre,
    };
  }

  // Create a copy with modified fields
  MovieModel copyWith({
    int? albumId,
    int? id,
    String? title,
    String? url,
    String? thumbnailUrl,
    double? rating,
    int? releaseYear,
    String? genre,
  }) {
    return MovieModel(
      albumId: albumId ?? this.albumId,
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      rating: rating ?? this.rating,
      releaseYear: releaseYear ?? this.releaseYear,
      genre: genre ?? this.genre,
    );
  }
}
