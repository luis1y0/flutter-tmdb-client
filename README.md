# kueski_app

A MovieDB app client.

## Dependencies

```
flutter pub add http sqflite bloc flutter_bloc provider flutter_dotenv
```

Test dependencies:

```
flutter pub add dev:mocktail
flutter pub add 'dev:integration_test:{"sdk":"flutter"}'
```

Running Unit Tests:

```
flutter test test/unit_test.dart
```

Running Integration Tests:

```
flutter test integration_test
```

Execute:

```
flutter run
```

## Workflow

1. First, based on the requirements I decided to design the main interfaces for
data sources and the related entities based on the json provided by MovieDB,
so I'm adding some unit tests to let me check the correctness before adding an
actual UI. Using Clean Architecture I'll focus in domain as a first step.

 - Define entities.
 - Define interfaces.
 - Define datasources' implementations and its dependencies.
 - Testing with mock dependecies of local storage and network calls.
 - Define a strategy to secure API key and avoid to expose it in source code.

I decided to use Mocktail instead of Mockito because was faster to create
the mocks with code generation and also, it was easyer to define method
parameters like any() without getting errors.

After defining the tests, it was necesary create Mocks of these clasess:

```dart
class MockLocalMoviesSource extends Mock implements LocalMoviesSource {}

class MockRemoteMoviesSource extends Mock implements RemoteMoviesSource {}

class MockSqliteMoviesSource extends Mock implements SqliteMoviesSource {}

class MockDatabase extends Mock implements Database {}

class MockHttpClient extends Mock implements http.Client {}
```

Because of that, all these classes were injected as dependencies by
constructor. I tested the main operations of parsing and conversion
with unit testing before starting to create UI.

2. The next step was the UI, at first I just decided to work with the most
basic elements, without for example, using a lot of widgets and creating
every small detail of decoration, from my point of view it was better to
define all the user interactions, which could be necessary the
intercommunication of widget many different parts of the widget tree, so,
that was the most dificult part of the UI, once all the user interactions
were working, it just was necesary adding decorations to all the existent
widgets without not much changes to the structure. Some important parts of
the code:

 - I used BLoC either just [Cubit](./lib/ui/blocs/pages_bloc.dart) or
 the properly [Bloc](./lib/ui/blocs/pagination_view/pagination_view_bloc.dart)
 with their events and states.
 - I implemented the lazy loading using Notification that a ScrollView fires,
 this using the [NotificationListener](./lib/ui/widgets/movie_list_widget.dart)
 widget. Because of this, it wasn't necessary to manipulate a ScrollController
 by hand.
 - I was using --dart-define to add environment variables, but when I was testing
 the release version that didn't work, at last moment I switched to use the
 flutter_dotenv library, trying to avoid loose more time.

3. I decided use Firebase Distribution, that was mentioned in the PDF, I create
a Github action that build the apk and using secret variables I was able to add
secrets like my API_KEY, without exposing it in the source code, and automaticly
upload it to Firebase distribution.
