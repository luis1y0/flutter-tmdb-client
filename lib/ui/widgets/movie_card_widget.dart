import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:kueski_app/domain/entities/movie.dart';

class MovieCardWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Movie movie;
  const MovieCardWidget({super.key, this.onTap, required this.movie});

  final TextStyle _textStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  final String baseImageUrl = 'https://image.tmdb.org/t/p/w500/';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                child: ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0,
                    tileMode: TileMode.decal,
                  ),
                  child: Image.network(
                    '$baseImageUrl${movie.posterPath}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Image.network(
                  '$baseImageUrl${movie.posterPath}',
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                child: Container(
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          style: _textStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        movie.voteAverage.toStringAsFixed(2),
                        style: _textStyle,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
