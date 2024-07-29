import 'package:bloc/bloc.dart';

enum TypeViewState { listView, gridView }

class TypeViewBloc extends Cubit<TypeViewState> {
  TypeViewBloc() : super(TypeViewState.listView);

  void switchListGrid() {
    if (state == TypeViewState.listView) {
      emit(TypeViewState.gridView);
    } else {
      emit(TypeViewState.listView);
    }
  }
}
