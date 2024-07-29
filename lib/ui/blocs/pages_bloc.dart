import 'package:bloc/bloc.dart';

class PagesBloc extends Cubit<int> {
  PagesBloc() : super(0);

  void setPage(int index) {
    emit(index);
  }
}
