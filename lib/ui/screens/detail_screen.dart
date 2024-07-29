import 'package:flutter/material.dart';
import 'package:kueski_app/domain/entities/movie.dart';
import 'package:kueski_app/ui/widgets/movie_card_widget.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;
  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextStyle _labelStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            MovieCardWidget(
              movie: widget.movie,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                Text(
                  'Genres: ',
                  style: _labelStyle,
                ),
                for (var genre in widget.movie.genres)
                  Chip(
                    label: Text(genre.name),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Language: ${widget.movie.originalLanguage.toUpperCase()}',
                  style: _labelStyle,
                ),
                Text(
                  'Ranking: ${widget.movie.popularity.toStringAsFixed(1)}',
                  style: _labelStyle,
                ),
              ],
            ),
            Text(
              'Released: ${_formatDate(widget.movie.releaseDate)}',
              style: _labelStyle,
            ),
            const Divider(
              height: 32,
            ),
            Text(widget.movie.overview),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime datetime) {
    int year = datetime.year;
    int month = datetime.month;
    int day = datetime.day;
    var now = DateTime.now();
    var difference = now.difference(datetime);
    String monthText = month.toString().padLeft(2, '0');
    String dayText = day.toString().padLeft(2, '0');
    String relativeTime = '';
    if (difference.inDays < 31) {
      relativeTime = '${difference.inDays} days ago';
    } else if (difference.inDays < 366 && datetime.year == now.year) {
      relativeTime = '${now.month - datetime.month} months ago';
    } else if (difference.inDays < 366) {
      relativeTime = '${now.month + (12 - datetime.month)} months ago';
    } else {
      relativeTime = '${now.year - datetime.year} years ago';
    }
    return '$year-$monthText-$dayText ($relativeTime)';
  }
}
