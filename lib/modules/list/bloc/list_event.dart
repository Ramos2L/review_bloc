part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object?> get props => [];
}

class ListEventAllData extends ListEvent {
  const ListEventAllData();

  @override
  List<Object?> get props => [];
}


class ListEventIncrementData extends ListEvent {
  final String value;
  const ListEventIncrementData({required this.value});

  @override
  List<Object?> get props => [value];
}

class ListEventRemovedData extends ListEvent {
  final int index;
  const ListEventRemovedData({required this.index});

  @override
  List<Object?> get props => [index];
}
