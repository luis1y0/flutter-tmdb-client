import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kueski_app/main.dart' as app;

void main() {
  group('App Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Switch between list and grid', (tester) async {
      await app.main();
      await tester.pumpAndSettle();
      // find icon button and tap
      final icon = find.byType(Icon).first;
      var list = find.byType(ListView).first;
      var grid = find.byType(GridView);
      // the default view it's a list
      expect(list, findsOne);
      expect(grid, findsNothing);
      await tester.tap(icon);
      await tester.pumpAndSettle();
      // now it must be a grid instead a list
      list = find.byType(ListView);
      grid = find.byType(GridView).first;
      expect(list, findsNothing);
      expect(grid, findsOne);
    });
    testWidgets('Correct message when no favorite movies are stored',
        (tester) async {
      await app.main();
      await tester.pumpAndSettle();
      // navigate to favorites page and check there aren't any movies
      final icon = find.byIcon(Icons.favorite);
      var favoriteMessage = find.text('There are no favorite movies.');
      expect(icon, findsOne);
      expect(favoriteMessage, findsNothing);
      await tester.tap(icon);
      await tester.pumpAndSettle();
      favoriteMessage = find.text('There are no favorite movies.');
      expect(favoriteMessage, findsOne);
    });
    testWidgets('Correctly add a movie to my favorites', (tester) async {
      await app.main();
      await tester.pumpAndSettle();
      // find image widgets in the first page and tap it to see de movie detail
      final movieCard = find.byType(Image);
      expect(movieCard, findsWidgets);
      await tester.tap(
        movieCard.first,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      // check we are in detail screen by the icon buttons of like and back
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOne);
      final likeButton = find.byIcon(Icons.favorite);
      expect(likeButton, findsOne);
      await tester.tap(
        likeButton,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      // like this movie
      await tester.tap(
        backButton,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      // navigate to favorites page and check the movie was added
      final favoriteButton = find.byIcon(Icons.favorite);
      expect(favoriteButton, findsOne);
      await tester.tap(
        favoriteButton,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      var favoriteMessage = find.text('There are no favorite movies.');
      expect(favoriteMessage, findsNothing);
    });
    testWidgets('Delete a movie of my favorites successfully', (tester) async {
      await app.main();
      await tester.pumpAndSettle();
      // first navigate to favorites page
      final icon = find.byIcon(Icons.favorite);
      var favoriteMessage = find.text('There are no favorite movies.');
      expect(icon, findsOne);
      expect(favoriteMessage, findsNothing);
      await tester.tap(icon);
      await tester.pumpAndSettle();
      // check the favorites list isn't empty so lets click in that movie
      favoriteMessage = find.text('There are no favorite movies.');
      expect(favoriteMessage, findsNothing);
      final movieCard = find.byType(Image);
      expect(movieCard, findsWidgets);
      await tester.tap(
        movieCard.first,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      // in detail screen lets click on favorite to dislike and return
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOne);
      final likeButton = find.byIcon(Icons.favorite);
      expect(likeButton, findsOne);
      await tester.tap(
        likeButton,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      await tester.tap(
        backButton,
        warnIfMissed: false,
      );
      // finally check if the favorite list is empty again
      await tester.pumpAndSettle();
      favoriteMessage = find.text('There are no favorite movies.');
      expect(favoriteMessage, findsOne);
    });
  });
}
