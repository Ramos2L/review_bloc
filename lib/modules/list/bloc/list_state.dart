part of 'list_bloc.dart';

abstract class ListState extends Equatable {
  final List<String> valueData;
  const ListState(this.valueData);

  @override
  List<Object?> get props => [valueData];
}


class ListStateInitial extends ListState {
  ListStateInitial() : super([]);

  @override
  List<Object?> get props => [];
}

class ListStateLoading extends ListState {
  const ListStateLoading(super.valueData);

  @override
  List<Object?> get props => [];
}

class ListStateSuccess extends ListState {
  const ListStateSuccess(super.valueData);

  @override
  List<Object?> get props => [];
}

class ListStateError extends ListState {
  final String messageError;
  ListStateError({required this.messageError}) : super( []);

  @override
  List<Object?> get props => [messageError];
}