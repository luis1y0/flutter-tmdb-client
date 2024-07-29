import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kueski_app/domain/repositories/movies_repository.dart';
import 'package:kueski_app/ui/blocs/pages_bloc.dart';
import 'package:kueski_app/ui/blocs/pagination_view/pagination_view_bloc.dart';
import 'package:kueski_app/ui/blocs/type_view_bloc.dart';
import 'package:kueski_app/ui/widgets/movies_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  late final PaginationViewBloc _nowPlayingBloc;
  late final PaginationViewBloc _popularBloc;
  @override
  void initState() {
    super.initState();
    _nowPlayingBloc = PaginationViewBloc(
      Provider.of<MoviesRepository>(
        context,
        listen: false,
      ),
      pageName: PageName.nowPlaying,
    );
    _popularBloc = PaginationViewBloc(
      Provider.of<MoviesRepository>(
        context,
        listen: false,
      ),
      pageName: PageName.popular,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MovieDbAPI'),
      ),
      body: BlocProvider<TypeViewBloc>(
        create: (context) => TypeViewBloc(),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            var pagesBloc = Provider.of<PagesBloc>(context, listen: false);
            pagesBloc.setPage(index);
          },
          children: [
            BlocProvider<PaginationViewBloc>.value(
              value: _nowPlayingBloc,
              child: const MoviesWidget(
                title: 'Now Playing Movies',
              ),
            ),
            BlocProvider<PaginationViewBloc>.value(
              value: _popularBloc,
              child: const MoviesWidget(
                title: 'Popular Movies',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<PagesBloc, int>(
        bloc: Provider.of<PagesBloc>(context),
        builder: (_, state) {
          var pagesBloc = Provider.of<PagesBloc>(context, listen: false);
          return BottomNavigationBar(
            currentIndex: state,
            onTap: (index) {
              pagesBloc.setPage(index);
              _pageController.animateTo(
                MediaQuery.sizeOf(context).width * index,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              );
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Now Playing',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up),
                label: 'Popular',
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nowPlayingBloc.close();
    _popularBloc.close();
    super.dispose();
  }
}
