// Movie Entity
// Core business entity for movies, independent of data sources

import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;
  
  const MovieEntity({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });
  
  @override
  List<Object> get props => [
    albumId,
    id, 
    title, 
    url, 
    thumbnailUrl,
  ];
}
