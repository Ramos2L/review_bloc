import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListStateInitial()) {
    on<ListEventIncrementData>(_onListEventIncrementData);
    on<ListEventRemovedData>(_onListEventRemovedData);
    on<ListEventAllData>(_onListEventAllData);
  }

  FutureOr<void> _onListEventIncrementData(ListEventIncrementData event, Emitter<ListState> emit) async {
    try {
      emit(ListStateLoading(state.valueData));
      await Future.delayed(const Duration(milliseconds: 200));

      final List<String> data = state.valueData..add(event.value);
      // final data = List<String>.from(state.valueData)..add(event.value);
      await _saveData(data);
      emit(ListStateSuccess(data));
    } catch (e) {
      emit(ListStateError(messageError: 'Ops, error! try again'));
    }
  }

  FutureOr<void> _onListEventRemovedData(ListEventRemovedData event, Emitter<ListState> emit) async {
    try {
      emit(ListStateLoading(state.valueData));
      final List<String> data = state.valueData..removeAt(event.index);
      await _saveData(data);
      emit(ListStateSuccess(data));
    } catch (e) {
      emit(ListStateError(messageError: 'Ops, error! try again'));
    }
  }

  FutureOr<void> _onListEventAllData(ListEventAllData event, Emitter<ListState> emit) async {
    try {
      emit(ListStateLoading(state.valueData));
      await Future.delayed(const Duration(milliseconds: 200));
      final List<String> allData = await loadData();
      emit(ListStateSuccess(allData));
    } catch (e) {
      emit(ListStateError(messageError: 'Ops, error search all data saved! try again'));
    }
  }

  Future<void> _saveData(List<String> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('data', data);
  }

  Future<List<String>> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loadDataList = prefs.getStringList('data') ?? [];
    return loadDataList;
  }
}
