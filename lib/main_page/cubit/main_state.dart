part of 'main_cubit.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class MainStateNormal extends MainState {
  final List<RegisterResult> results;

  MainStateNormal(this.results);

  @override
  List<Object> get props => [results];
}
