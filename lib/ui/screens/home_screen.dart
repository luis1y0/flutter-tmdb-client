import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kueski_app/ui/blocs/pages_bloc.dart';
import 'package:kueski_app/ui/widgets/movies_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MovieDbAPI'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          var pagesBloc = Provider.of<PagesBloc>(context, listen: false);
          pagesBloc.setPage(index);
        },
        children: const [
          MoviesWidget(
            title: 'Now Playing Movies',
          ),
          MoviesWidget(
            title: 'Popular Movies',
          ),
        ],
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
}
